# Operational Runbooks — TaskFlow

> **Project**: TaskFlow
> **Version**: draft
> **Date Created**: 2026-04-06
> **Last Updated**: 2026-04-06
> **Status**: Draft
> **Author**: AI-Generated
> **Source**: Based on `monitoring-plan-final.md` and `env-spec-final.md`

---

## 1. Runbook Inventory

| ID | Title | Category | Trigger | Severity | Last Tested | Confidence |
|----|-------|----------|---------|----------|-------------|------------|
| RB-001 | API Error Rate High | Alert Response | API 5xx error rate >5% for 5 min | P2 — High | Not yet tested | 🔶 ASSUMED |
| RB-002 | API Latency High | Alert Response | API p99 latency >2s for 5 min | P2 — High | Not yet tested | 🔶 ASSUMED |
| RB-003 | Database Connection Pool Exhaustion | Alert Response | Active connections >80% of max (160/200) | P1 — Critical | Not yet tested | 🔶 ASSUMED |
| RB-004 | Redis Memory High | Alert Response | Redis memory usage >80% (1.2GB/1.5GB) | P2 — High | Not yet tested | 🔶 ASSUMED |
| RB-005 | ECS Task Count Zero | Alert Response | Running tasks = 0 for api-server service | P1 — Critical | Not yet tested | 🔶 ASSUMED |
| RB-006 | SSL Certificate Expiring | Alert Response | Certificate expires within 14 days | P3 — Medium | Not yet tested | 🔶 ASSUMED |
| RB-007 | Database Backup Verification | Routine Ops | Monthly schedule (1st Monday) | P4 — Low | Not yet tested | 🔶 ASSUMED |
| RB-008 | Dependency Security Update | Routine Ops | Weekly schedule (Wednesday) | P3 — Medium | Not yet tested | 🔶 ASSUMED |
| RB-009 | Standard Deployment | Deployment | Release ready for production | P3 — Medium | Not yet tested | 🔶 ASSUMED |
| RB-010 | Emergency Rollback | Deployment | Production incident after deploy | P1 — Critical | Not yet tested | 🔶 ASSUMED |
| RB-011 | Database Point-in-Time Recovery | Disaster Recovery | Database corruption or data loss | P1 — Critical | Not yet tested | ❓ UNCLEAR |
| RB-012 | Full Service Recovery | Disaster Recovery | Complete service outage | P1 — Critical | Not yet tested | ❓ UNCLEAR |

---

## 2. Alert Response Runbooks

### RB-001: API Error Rate High

> **Category**: Alert Response
> **Severity**: P2 — High
> **Trigger**: API 5xx error rate >5% for 5 minutes (Datadog monitor `taskflow.api.error_rate`)
> **Impact**: Users experience failed requests — task creation, updates, and reads may fail intermittently or completely
> **Estimated Resolution Time**: 15-30 minutes
> **Owner**: Backend Team
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check error rate in Datadog APM**
   ```
   Open: https://app.datadoghq.com/apm/services/taskflow-api/operations/http.request
   Time range: Last 30 minutes
   ```
   - Look at: Error rate graph and error breakdown by endpoint
   - Identify: Which endpoints are producing 5xx errors

2. **Check application logs for error details**
   ```
   aws logs filter-log-events \
     --log-group-name /ecs/taskflow-api-prod \
     --filter-pattern "ERROR" \
     --start-time $(date -d '30 minutes ago' +%s000) \
     --query 'events[*].[timestamp,message]' \
     --output text | tail -50
   ```
   - Look for: Stack traces, database connection errors, timeout errors
   - If database errors: go to RB-003 (Database Connection Pool Exhaustion)
   - If timeout errors: go to RB-002 (API Latency High)

3. **Check recent deployments**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].deployments[*].{status:status,created:createdAt,desired:desiredCount,running:runningCount}' \
     --output table
   ```
   - If a deployment was created in the last 30 minutes: likely deploy-related, go to Remediation Option A
   - If no recent deployment: go to Step 4

4. **Check ECS task health**
   ```
   aws ecs list-tasks --cluster taskflow-prod --service-name api-server --query 'taskArns' --output text | \
   xargs -I {} aws ecs describe-tasks --cluster taskflow-prod --tasks {} \
     --query 'tasks[*].{id:taskArn,status:lastStatus,health:healthStatus,started:startedAt}' \
     --output table
   ```
   - If tasks are unhealthy or restarting: go to Remediation Option B
   - If tasks are healthy: go to Remediation Option C

#### Remediation

**Option A: Deploy-related (recent deployment in last 30 minutes)**

1. **Roll back to previous task definition**
   ```
   # Get the previous task definition
   CURRENT_TD=$(aws ecs describe-services --cluster taskflow-prod --services api-server \
     --query 'services[0].taskDefinition' --output text)
   PREV_REVISION=$(($(echo $CURRENT_TD | grep -o '[0-9]*$') - 1))
   PREV_TD=$(echo $CURRENT_TD | sed "s/[0-9]*$/$PREV_REVISION/")

   # Roll back
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --task-definition $PREV_TD \
     --query 'service.deployments[0].{status:status,taskDef:taskDefinition}' \
     --output table
   ```
   - Expected: New deployment created with previous task definition
   - Wait: ~3-5 minutes for new tasks to stabilize

2. **Verify rollback**
   - Go to Verification section

**Option B: Task health issues (tasks unhealthy or restarting)**

1. **Force new deployment to restart tasks**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --force-new-deployment \
     --query 'service.deployments[0].{status:status,desired:desiredCount,running:runningCount}' \
     --output table
   ```
   - Expected: status=PRIMARY, running count will reach desired count within ~3 minutes
   - If tasks keep failing after restart: escalate

**Option C: No obvious cause (no recent deploy, tasks healthy)**

1. **Check if load spike is causing errors**
   ```
   Open: https://app.datadoghq.com/dashboard/taskflow-overview
   Check: Request rate graph — is traffic significantly above normal?
   ```
   - If traffic spike: scale up the service
     ```
     aws ecs update-service \
       --cluster taskflow-prod \
       --service api-server \
       --desired-count 4 \
       --query 'service.{desired:desiredCount,running:runningCount}' \
       --output table
     ```
   - If traffic normal: escalate to Backend Team for code-level investigation

#### Verification

1. **Check error rate recovery**
   ```
   Open: https://app.datadoghq.com/apm/services/taskflow-api/operations/http.request
   ```
   - Expected: Error rate drops below 5% within 5-10 minutes of remediation

2. **Test API endpoint**
   ```
   curl -s -o /dev/null -w "%{http_code} %{time_total}s" \
     https://api.taskflow.example.com/health
   ```
   - Expected: HTTP 200, response time <500ms

3. **Test core functionality**
   ```
   # List tasks
   curl -s -w "\n%{http_code}" https://api.taskflow.example.com/api/tasks?limit=5
   ```
   - Expected: HTTP 200 with JSON response

4. **Monitor for 15 minutes** to confirm stability. If alert re-fires, escalate.

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Not resolved within 15 min | Backend Tech Lead | Slack: #taskflow-incidents, PagerDuty | Timeline, error patterns, steps taken |
| Rollback failed | SRE On-Call | PagerDuty escalation | Current task definition, error logs |
| Root cause unknown after 30 min | Engineering Manager | Slack DM + PagerDuty | Full incident timeline, all diagnostics |

---

### RB-002: API Latency High

> **Category**: Alert Response
> **Severity**: P2 — High
> **Trigger**: API p99 latency >2s for 5 minutes (Datadog monitor `taskflow.api.latency.p99`)
> **Impact**: Users experience slow page loads, timeouts on task operations; SLA at risk
> **Estimated Resolution Time**: 15-30 minutes
> **Owner**: Backend Team
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check latency breakdown in Datadog APM**
   ```
   Open: https://app.datadoghq.com/apm/traces?query=service:taskflow-api%20duration:>2s
   ```
   - Identify: Which endpoints are slow, where time is spent (app code, database, Redis, external calls)

2. **Check for slow database queries**
   ```
   # Connect to RDS and check active queries
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_readonly -d taskflow -c "
     SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state
     FROM pg_stat_activity
     WHERE state != 'idle'
       AND (now() - pg_stat_activity.query_start) > interval '5 seconds'
     ORDER BY duration DESC
     LIMIT 10;
   "
   ```
   - If long-running queries found: go to Remediation Option A

3. **Check Redis cache hit rate**
   ```
   Open: https://app.datadoghq.com/dashboard/taskflow-redis
   Check: Cache hit rate (should be >90%), command latency, connected clients
   ```
   - If hit rate <90%: go to Remediation Option B

4. **Check ECS CPU and memory utilization**
   ```
   aws cloudwatch get-metric-statistics \
     --namespace AWS/ECS \
     --metric-name CPUUtilization \
     --dimensions Name=ClusterName,Value=taskflow-prod Name=ServiceName,Value=api-server \
     --start-time $(date -u -d '30 minutes ago' +%Y-%m-%dT%H:%M:%S) \
     --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
     --period 300 --statistics Average \
     --output table
   ```
   - If CPU >80%: go to Remediation Option C

#### Remediation

**Option A: Slow database queries**

1. **Identify and terminate the problematic query**
   ```
   # SAFETY CHECK: Verify this is not a migration or scheduled job
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
     SELECT pid, usename, query_start, state, query
     FROM pg_stat_activity
     WHERE pid = {PID_FROM_DIAGNOSIS};
   "
   ```
   - If query is a known migration: DO NOT KILL. Wait for completion or escalate to DBA.
   - If query is an application query running >10 minutes:
     ```
     psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
       SELECT pg_terminate_backend({PID});
     "
     ```

2. **If query pattern is recurring, add to backlog for optimization**
   - Note the query pattern for post-incident follow-up

**Option B: Low Redis cache hit rate**

1. **Check Redis memory and eviction**
   ```
   aws elasticache describe-cache-clusters \
     --cache-cluster-id taskflow-prod-redis \
     --show-cache-node-info \
     --query 'CacheClusters[0].CacheNodes[0].{endpoint:Endpoint,status:CacheNodeStatus}'
   ```

2. **Flush expired keys if memory is high**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     INFO memory
   ```
   - If used_memory is >80% of maxmemory: consider clearing session cache
     ```
     redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
       EVAL "local keys = redis.call('keys', 'session:expired:*') for i=1,#keys do redis.call('del', keys[i]) end return #keys" 0
     ```

**Option C: High CPU utilization**

1. **Scale up the API service**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --desired-count 4 \
     --query 'service.{desired:desiredCount,running:runningCount}' \
     --output table
   ```
   - Wait: ~3 minutes for new tasks to register with ALB

#### Verification

1. **Check latency recovery**
   ```
   Open: https://app.datadoghq.com/apm/services/taskflow-api/operations/http.request
   ```
   - Expected: p99 latency drops below 2s within 5-10 minutes

2. **Test API response time**
   ```
   curl -s -o /dev/null -w "HTTP %{http_code} — %{time_total}s\n" \
     https://api.taskflow.example.com/api/tasks?limit=10
   ```
   - Expected: Response time <500ms

3. **Monitor for 15 minutes** to confirm stability.

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Not resolved within 15 min | Backend Tech Lead | Slack: #taskflow-incidents | Slow query details, APM traces |
| Database performance issue | DBA / SRE | PagerDuty | Query patterns, RDS metrics |
| Sustained high traffic | Engineering Manager | Slack DM | Traffic volume, scaling limits |

---

### RB-003: Database Connection Pool Exhaustion

> **Category**: Alert Response
> **Severity**: P1 — Critical
> **Trigger**: Active PostgreSQL connections >80% of max (160 of 200) for 3 minutes
> **Impact**: New requests fail with "connection pool exhausted" errors; complete API unavailability imminent
> **Estimated Resolution Time**: 10-20 minutes
> **Owner**: Backend Team / DBA
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check current connection count**
   ```
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_readonly -d taskflow -c "
     SELECT count(*) AS total_connections,
            count(*) FILTER (WHERE state = 'active') AS active,
            count(*) FILTER (WHERE state = 'idle') AS idle,
            count(*) FILTER (WHERE state = 'idle in transaction') AS idle_in_txn
     FROM pg_stat_activity
     WHERE datname = 'taskflow';
   "
   ```
   - If idle_in_txn is high (>20): likely connection leak, go to Step 2
   - If active is high: likely load spike, go to Step 3

2. **Identify long-running or stuck transactions**
   ```
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_readonly -d taskflow -c "
     SELECT pid, usename, state, query_start,
            now() - query_start AS duration, query
     FROM pg_stat_activity
     WHERE state = 'idle in transaction'
       AND now() - query_start > interval '5 minutes'
     ORDER BY duration DESC
     LIMIT 20;
   "
   ```
   - Record PIDs for remediation

3. **Check connection count by source**
   ```
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_readonly -d taskflow -c "
     SELECT usename, application_name, client_addr, count(*)
     FROM pg_stat_activity
     WHERE datname = 'taskflow'
     GROUP BY usename, application_name, client_addr
     ORDER BY count DESC;
   "
   ```
   - Identify which service/host is consuming the most connections

#### Remediation

1. **Kill stuck idle-in-transaction connections**
   ```
   # SAFETY CHECK: Review queries before killing
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
     SELECT pid, query FROM pg_stat_activity
     WHERE state = 'idle in transaction'
       AND now() - query_start > interval '10 minutes';
   "
   ```
   - If safe to proceed (no migrations or critical batch jobs):
     ```
     psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
       SELECT pg_terminate_backend(pid)
       FROM pg_stat_activity
       WHERE state = 'idle in transaction'
         AND now() - query_start > interval '10 minutes';
     "
     ```

2. **If connections still high, temporarily increase max connections**
   ```
   # Modify RDS parameter group (takes effect without reboot for this parameter)
   aws rds modify-db-parameter-group \
     --db-parameter-group-name taskflow-prod-params \
     --parameters "ParameterName=max_connections,ParameterValue=300,ApplyMethod=immediate"
   ```
   - TEMPORARY FIX: Schedule permanent fix for connection pooling (PgBouncer) in next sprint

3. **Restart API service to reset connection pools**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --force-new-deployment
   ```
   - Wait: ~3-5 minutes for rolling restart

#### Verification

1. **Check connection count returned to normal**
   ```
   psql -h taskflow-prod.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_readonly -d taskflow -c "
     SELECT count(*) FROM pg_stat_activity WHERE datname = 'taskflow';
   "
   ```
   - Expected: Connection count <100 (well below 200 max)

2. **Test API health**
   ```
   curl -s -o /dev/null -w "%{http_code}" https://api.taskflow.example.com/health
   ```
   - Expected: HTTP 200

3. **Monitor for 15 minutes** — watch connection count trend in Datadog.

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Connections keep climbing after kill | DBA / SRE | PagerDuty | Connection breakdown by source, leak suspect |
| Cannot modify parameter group | AWS Support + SRE | PagerDuty + AWS case | RDS instance ID, current connections |
| Not resolved within 10 min | Engineering Manager | Slack + PagerDuty | Full timeline, connection stats |

---

### RB-004: Redis Memory High

> **Category**: Alert Response
> **Severity**: P2 — High
> **Trigger**: Redis used_memory >80% of maxmemory (>1.2GB of 1.5GB) for 5 minutes
> **Impact**: Cache evictions increase, cache hit rate drops, API latency increases; risk of OOM if trend continues
> **Estimated Resolution Time**: 15-30 minutes
> **Owner**: Backend Team
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check Redis memory details**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 INFO memory
   ```
   - Note: used_memory_human, used_memory_peak_human, maxmemory_human
   - Check: mem_fragmentation_ratio (>1.5 indicates fragmentation)

2. **Check eviction rate**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 INFO stats | grep evicted_keys
   ```
   - If evictions are increasing: keys are being dropped, performance impact active

3. **Identify large key patterns**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     --bigkeys --memkeys
   ```
   - Record the largest keys and their types for remediation

4. **Check key count by prefix**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     EVAL "local counts = {} local cursor = '0' repeat local result = redis.call('SCAN', cursor, 'COUNT', 1000) cursor = result[1] for _,key in ipairs(result[2]) do local prefix = string.match(key, '^([^:]+)') counts[prefix] = (counts[prefix] or 0) + 1 end until cursor == '0' local output = '' for k,v in pairs(counts) do output = output .. k .. ':' .. v .. ' ' end return output" 0
   ```
   - Identify which key prefix is consuming the most space

#### Remediation

1. **Clear expired session data**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     EVAL "local keys = redis.call('keys', 'sess:*') local deleted = 0 for i=1,#keys do local ttl = redis.call('ttl', keys[i]) if ttl == -1 then redis.call('del', keys[i]) deleted = deleted + 1 end end return deleted" 0
   ```
   - Expected: Returns count of deleted keys with no TTL set

2. **If memory still high, flush non-critical caches**
   ```
   # Clear API response cache (will be rebuilt on next request)
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     EVAL "return redis.call('del', unpack(redis.call('keys', 'cache:api:*')))" 0
   ```
   - SAFETY CHECK: Do NOT flush session data (`sess:active:*`) — this would log out users

3. **If persistent issue, scale up Redis node**
   ```
   aws elasticache modify-replication-group \
     --replication-group-id taskflow-prod-redis \
     --cache-node-type cache.t3.medium \
     --apply-immediately
   ```
   - Warning: This causes a brief failover (~30 seconds). Schedule during low-traffic window if possible.
   - Wait: ~5-10 minutes for modification to complete

#### Verification

1. **Check memory usage dropped**
   ```
   redis-cli -h taskflow-prod-redis.xxxxx.cache.amazonaws.com -p 6379 \
     INFO memory | grep used_memory_human
   ```
   - Expected: used_memory below 80% of maxmemory

2. **Check cache hit rate recovering**
   ```
   Open: https://app.datadoghq.com/dashboard/taskflow-redis
   ```
   - Expected: Hit rate returns to >90% within 10-15 minutes

3. **Monitor for 15 minutes** to ensure memory does not climb back.

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Memory keeps climbing after cleanup | Backend Tech Lead | Slack: #taskflow-incidents | Key breakdown, growth rate |
| Need to scale node (causes failover) | SRE + Engineering Manager | PagerDuty | Current memory, failover impact |
| Suspect memory leak in application | Backend Tech Lead | Slack | Key patterns, growth rate, suspect code |

---

### RB-005: ECS Task Count Zero

> **Category**: Alert Response
> **Severity**: P1 — Critical
> **Trigger**: Running tasks = 0 for api-server service in ECS cluster taskflow-prod
> **Impact**: Complete API outage — all user requests fail, no tasks can be created or viewed
> **Estimated Resolution Time**: 5-15 minutes
> **Owner**: SRE / Backend Team
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check ECS service events for failure reason**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].events[:10].[createdAt,message]' \
     --output table
   ```
   - Look for: "unable to place task", "essential container exited", "health check failed"

2. **Check recent deployment status**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].deployments[*].{status:status,desired:desiredCount,running:runningCount,failed:failedTasks,taskDef:taskDefinition}' \
     --output table
   ```
   - If a deployment has failedTasks >0: likely bad deploy, go to Remediation Option A
   - If no deployment issues: go to Step 3

3. **Check stopped task reasons**
   ```
   aws ecs list-tasks --cluster taskflow-prod --service-name api-server --desired-status STOPPED \
     --query 'taskArns[:3]' --output text | \
   xargs -I {} aws ecs describe-tasks --cluster taskflow-prod --tasks {} \
     --query 'tasks[*].{reason:stoppedReason,exitCode:containers[0].exitCode,status:lastStatus}' \
     --output table
   ```
   - If stoppedReason contains "OutOfMemory": go to Remediation Option B
   - If exitCode is non-zero: application crash, go to Remediation Option C

#### Remediation

**Option A: Bad deployment**

1. **Roll back to previous task definition**
   ```
   CURRENT_TD=$(aws ecs describe-services --cluster taskflow-prod --services api-server \
     --query 'services[0].taskDefinition' --output text)
   PREV_REVISION=$(($(echo $CURRENT_TD | grep -o '[0-9]*$') - 1))
   PREV_TD=$(echo $CURRENT_TD | sed "s/[0-9]*$/$PREV_REVISION/")

   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --task-definition $PREV_TD \
     --desired-count 2
   ```
   - Wait: ~3-5 minutes for tasks to start and pass health checks

**Option B: Out of memory**

1. **Register new task definition with increased memory**
   ```
   # Get current task definition
   aws ecs describe-task-definition \
     --task-definition taskflow-api-prod \
     --query 'taskDefinition.{cpu:cpu,memory:memory}' \
     --output table
   ```
   - Increase memory in task definition (e.g., 1024 -> 2048)
   - Redeploy with updated task definition
   - TEMPORARY FIX: investigate memory leak in next sprint

**Option C: Application crash**

1. **Force new deployment with current task definition**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --force-new-deployment \
     --desired-count 2
   ```
   - Wait: ~3 minutes
   - If tasks keep crashing: check application logs and escalate

#### Verification

1. **Confirm tasks are running**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].{desired:desiredCount,running:runningCount,pending:pendingCount}' \
     --output table
   ```
   - Expected: running = desired (2)

2. **Test health endpoint**
   ```
   curl -s -o /dev/null -w "%{http_code}" https://api.taskflow.example.com/health
   ```
   - Expected: HTTP 200

3. **Verify ALB target health**
   ```
   aws elbv2 describe-target-health \
     --target-group-arn arn:aws:elasticloadbalancing:us-east-1:123456789:targetgroup/taskflow-api/xxxxx \
     --query 'TargetHealthDescriptions[*].{target:Target.Id,health:TargetHealth.State}' \
     --output table
   ```
   - Expected: All targets "healthy"

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Tasks won't start after rollback | SRE Lead | PagerDuty (P1) | ECS events, stopped task reasons |
| Immediate (P1 — total outage) | Engineering Manager | PagerDuty + Phone | Current state, ETA |
| Root cause unknown | Backend Tech Lead | Slack + PagerDuty | Logs, task exit codes, timeline |

---

### RB-006: SSL Certificate Expiring

> **Category**: Alert Response
> **Severity**: P3 — Medium
> **Trigger**: SSL certificate for *.taskflow.example.com expires within 14 days
> **Impact**: No immediate user impact; if certificate expires, all HTTPS connections will fail
> **Estimated Resolution Time**: 15-30 minutes
> **Owner**: SRE / DevOps
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Diagnosis

1. **Check certificate status in ACM**
   ```
   aws acm list-certificates \
     --query 'CertificateSummaryList[?DomainName==`*.taskflow.example.com`].{domain:DomainName,arn:CertificateArn,status:Status}' \
     --output table
   ```

2. **Check certificate details and expiration**
   ```
   aws acm describe-certificate \
     --certificate-arn arn:aws:acm:us-east-1:123456789:certificate/xxxxx \
     --query 'Certificate.{domain:DomainName,status:Status,notAfter:NotAfter,renewalSummary:RenewalSummary}' \
     --output json
   ```
   - If RenewalStatus is "PENDING_VALIDATION": DNS validation record may be missing
   - If RenewalStatus is "SUCCESS": renewal is in progress, monitor

3. **Verify certificate on the live endpoint**
   ```
   echo | openssl s_client -connect api.taskflow.example.com:443 -servername api.taskflow.example.com 2>/dev/null | \
     openssl x509 -noout -dates -subject
   ```
   - Confirm expiration date matches ACM

#### Remediation

1. **If ACM auto-renewal failed, check DNS validation**
   ```
   aws acm describe-certificate \
     --certificate-arn arn:aws:acm:us-east-1:123456789:certificate/xxxxx \
     --query 'Certificate.DomainValidationOptions[*].{domain:DomainName,status:ValidationStatus,cname:ResourceRecord}' \
     --output table
   ```
   - If ValidationStatus is not "SUCCESS": add the CNAME record to Route 53
     ```
     aws route53 change-resource-record-sets \
       --hosted-zone-id ZXXXXX \
       --change-batch '{
         "Changes": [{
           "Action": "UPSERT",
           "ResourceRecordSet": {
             "Name": "{CNAME_NAME_FROM_ABOVE}",
             "Type": "CNAME",
             "TTL": 300,
             "ResourceRecords": [{"Value": "{CNAME_VALUE_FROM_ABOVE}"}]
           }
         }]
       }'
     ```

2. **If certificate cannot be renewed, request a new one**
   ```
   aws acm request-certificate \
     --domain-name "*.taskflow.example.com" \
     --validation-method DNS \
     --subject-alternative-names "taskflow.example.com"
   ```
   - Then validate and associate with ALB/CloudFront

#### Verification

1. **Check certificate renewal status**
   ```
   aws acm describe-certificate \
     --certificate-arn arn:aws:acm:us-east-1:123456789:certificate/xxxxx \
     --query 'Certificate.{status:Status,notAfter:NotAfter,renewal:RenewalSummary.RenewalStatus}'
   ```
   - Expected: RenewalStatus = "SUCCESS", NotAfter updated to future date

2. **Verify live certificate**
   ```
   echo | openssl s_client -connect api.taskflow.example.com:443 -servername api.taskflow.example.com 2>/dev/null | \
     openssl x509 -noout -dates
   ```
   - Expected: notAfter is >30 days from now

#### Escalation

| Condition | Escalate To | Contact | Information to Provide |
|-----------|------------|---------|----------------------|
| Certificate expires in <3 days | SRE Lead | PagerDuty (upgrade to P2) | Certificate ARN, expiration date |
| DNS validation failing | DNS/Domain admin | Slack: #infrastructure | Validation CNAME details |
| ACM service issue | AWS Support | AWS Support case | Certificate ARN, error details |

---

## 3. Routine Operations Runbooks

### RB-007: Database Backup Verification

> **Category**: Routine Operations
> **Schedule**: Monthly — 1st Monday of each month, during business hours
> **Responsible**: DBA / SRE
> **Estimated Duration**: 1-2 hours
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Prerequisites

- AWS CLI configured with production read access
- Access to create RDS instances in staging account
- Staging VPC security group allows database connections

#### Procedure

1. **Identify latest automated backup**
   ```
   aws rds describe-db-snapshots \
     --db-instance-identifier taskflow-prod \
     --snapshot-type automated \
     --query 'DBSnapshots | sort_by(@, &SnapshotCreateTime) | [-1].{id:DBSnapshotIdentifier,created:SnapshotCreateTime,status:Status,size:AllocatedStorage}' \
     --output table
   ```

2. **Restore backup to test instance in staging**
   ```
   aws rds restore-db-instance-from-db-snapshot \
     --db-instance-identifier taskflow-backup-verify-$(date +%Y%m%d) \
     --db-snapshot-identifier {SNAPSHOT_ID_FROM_STEP_1} \
     --db-instance-class db.t3.micro \
     --db-subnet-group-name taskflow-staging-subnet \
     --vpc-security-group-ids sg-xxxxx \
     --no-multi-az \
     --tags Key=Purpose,Value=backup-verification Key=DeleteAfter,Value=$(date -d '+1 day' +%Y-%m-%d)
   ```
   - Wait: ~15-30 minutes for restore to complete
   - Check status:
     ```
     aws rds describe-db-instances \
       --db-instance-identifier taskflow-backup-verify-$(date +%Y%m%d) \
       --query 'DBInstances[0].DBInstanceStatus'
     ```

3. **Run validation queries**
   ```
   psql -h taskflow-backup-verify-$(date +%Y%m%d).xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
     SELECT 'users' AS tbl, count(*) AS cnt FROM users
     UNION ALL
     SELECT 'tasks', count(*) FROM tasks
     UNION ALL
     SELECT 'projects', count(*) FROM projects;
   "
   ```
   - Compare counts with production (should be within expected range)
   - Run a sample query to verify data integrity:
     ```
     psql -h taskflow-backup-verify-$(date +%Y%m%d).xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
       SELECT id, email, created_at FROM users ORDER BY created_at DESC LIMIT 5;
     "
     ```

4. **Delete test instance**
   ```
   aws rds delete-db-instance \
     --db-instance-identifier taskflow-backup-verify-$(date +%Y%m%d) \
     --skip-final-snapshot
   ```

#### Verification

1. **Document results**
   - Record: backup date, restore time, row counts, data integrity check result
   - Update this runbook's "Last Tested" date
   - If any issues found: create a ticket for investigation

#### Rollback

Not applicable — this is a read-only verification procedure on a disposable test instance.

---

### RB-008: Dependency Security Update

> **Category**: Routine Operations
> **Schedule**: Weekly — Wednesday morning
> **Responsible**: Backend Team (rotating)
> **Estimated Duration**: 1-2 hours
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Prerequisites

- Repository cloned and up to date
- Node.js and npm installed (matching project version)
- Access to create PRs in GitHub

#### Procedure

1. **Run security audit**
   ```
   cd /path/to/taskflow
   npm audit --json > /tmp/audit-results.json
   cat /tmp/audit-results.json | jq '{total: .metadata.totalDependencies, vulnerabilities: .metadata.vulnerabilities}'
   ```
   - If no vulnerabilities: document "no action needed" and stop
   - If vulnerabilities found: continue to Step 2

2. **Assess severity**
   ```
   cat /tmp/audit-results.json | jq '.vulnerabilities | to_entries[] | {name: .key, severity: .value.severity, fixAvailable: .value.fixAvailable}'
   ```
   - Critical/High: must be patched this week
   - Moderate: patch if fix is available, otherwise schedule
   - Low: batch with next regular update

3. **Apply patches**
   ```
   git checkout -b security/dep-update-$(date +%Y%m%d)
   npm audit fix
   npm test
   ```
   - If `npm audit fix` cannot resolve: check if `npm audit fix --force` is safe (review breaking changes)
   - If breaking changes required: create separate ticket for major version upgrade

4. **Create PR**
   ```
   git add package.json package-lock.json
   git commit -m "fix: apply dependency security patches $(date +%Y-%m-%d)"
   git push -u origin security/dep-update-$(date +%Y%m%d)
   gh pr create --title "Security: dependency patches $(date +%Y-%m-%d)" \
     --body "Weekly security patch update. See npm audit results for details."
   ```

5. **Deploy to staging and verify**
   - Merge PR after review
   - Verify staging deployment succeeds
   - Run E2E tests on staging
   - Deploy to production following RB-009 (Standard Deployment)

#### Verification

1. **Re-run audit after deployment**
   ```
   npm audit
   ```
   - Expected: No critical or high vulnerabilities remaining

---

## 4. Deployment Runbooks

### RB-009: Standard Deployment

> **Category**: Deployment
> **Trigger**: Release branch merged to main, CI pipeline passes all checks
> **Severity**: P3 — Medium
> **Estimated Duration**: 30-45 minutes
> **Owner**: Backend Team / Release Manager
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Pre-Deployment Checks

1. **Verify CI is green on main**
   ```
   gh run list --branch main --limit 1 --json status,conclusion,headSha \
     --jq '.[0] | "\(.status) \(.conclusion) \(.headSha)"'
   ```
   - Required: status=completed, conclusion=success

2. **Verify staging deployment is current and healthy**
   ```
   curl -s https://staging-api.taskflow.example.com/health | jq '.version'
   ```
   - Required: Version matches the commit being deployed

3. **Check for active incidents**
   ```
   Open: https://taskflow.statuspage.io/
   ```
   - Required: No active P1/P2 incidents
   - If active incident: postpone deployment unless this deploy is the fix

4. **Notify team**
   - Post in Slack #taskflow-deploys: "Starting production deployment of {version}"

#### Deployment Steps

1. **Deploy to production via GitHub Actions**
   ```
   gh workflow run deploy-prod.yml --ref main
   ```
   - Wait: ~5-10 minutes for deployment to complete

2. **Monitor deployment progress**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].deployments[*].{status:status,running:runningCount,desired:desiredCount,rollout:rolloutState}' \
     --output table
   ```
   - Expected: PRIMARY deployment shows running = desired, rolloutState = COMPLETED

#### Post-Deployment Verification

1. **Run smoke tests**
   ```
   curl -s https://api.taskflow.example.com/health | jq '.'
   ```
   - Expected: HTTP 200, correct version, all checks passing

2. **Test core user flows**
   ```
   # Create a test task
   curl -s -X POST https://api.taskflow.example.com/api/tasks \
     -H "Authorization: Bearer $TEST_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"title":"Deploy smoke test","projectId":"test-project"}' | jq '.id'

   # List tasks
   curl -s https://api.taskflow.example.com/api/tasks?limit=5 \
     -H "Authorization: Bearer $TEST_TOKEN" | jq '.data | length'
   ```
   - Expected: Task created successfully, list returns results

3. **Monitor for 30 minutes**
   ```
   Open: https://app.datadoghq.com/dashboard/taskflow-overview
   ```
   - Watch: Error rate (<1%), p99 latency (<2s), task count (stable at desired)
   - If any metric degrades: initiate RB-010 (Emergency Rollback)

4. **Announce completion**
   - Post in Slack #taskflow-deploys: "Production deployment of {version} complete. All checks passing."

#### Rollback Procedure

If issues are detected during the 30-minute monitoring window, execute RB-010 (Emergency Rollback).

#### Communication

- [ ] Pre-deploy: Slack #taskflow-deploys notification
- [ ] Post-deploy: Slack #taskflow-deploys confirmation
- [ ] If issues: Slack #taskflow-incidents + status page update

---

### RB-010: Emergency Rollback

> **Category**: Deployment
> **Trigger**: Production incident detected after deployment (error spike, latency spike, functionality broken)
> **Severity**: P1 — Critical
> **Estimated Duration**: 5-10 minutes
> **Owner**: On-Call Engineer / Release Manager
> **Last Tested**: Not yet tested
> **Confidence**: 🔶 ASSUMED

#### Pre-Deployment Checks

1. **Confirm this is deploy-related**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].deployments[*].{status:status,created:createdAt,taskDef:taskDefinition}' \
     --output table
   ```
   - Verify: A deployment happened within the time window of the incident

#### Deployment Steps

1. **Identify previous task definition**
   ```
   CURRENT_TD=$(aws ecs describe-services --cluster taskflow-prod --services api-server \
     --query 'services[0].taskDefinition' --output text)
   echo "Current: $CURRENT_TD"

   PREV_REVISION=$(($(echo $CURRENT_TD | grep -o '[0-9]*$') - 1))
   PREV_TD=$(echo $CURRENT_TD | sed "s/[0-9]*$/$PREV_REVISION/")
   echo "Rolling back to: $PREV_TD"
   ```

2. **Execute rollback**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --task-definition $PREV_TD \
     --query 'service.deployments[0].{status:status,taskDef:taskDefinition,desired:desiredCount}' \
     --output table
   ```
   - Wait: ~3-5 minutes for new tasks to start and old tasks to drain

3. **Update status page**
   ```
   Open: https://manage.statuspage.io/pages/xxxxx/incidents
   Create incident: "Investigating elevated error rates. Rollback in progress."
   ```

#### Post-Deployment Verification

1. **Confirm rollback completed**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server \
     --query 'services[0].{running:runningCount,desired:desiredCount,taskDef:taskDefinition}' \
     --output table
   ```
   - Expected: running = desired, taskDefinition = previous version

2. **Verify service health**
   ```
   curl -s -o /dev/null -w "%{http_code} %{time_total}s" https://api.taskflow.example.com/health
   ```
   - Expected: HTTP 200, response time <500ms

3. **Verify metrics recovering**
   ```
   Open: https://app.datadoghq.com/dashboard/taskflow-overview
   ```
   - Expected: Error rate and latency returning to pre-deploy baseline within 5-10 minutes

4. **Update status page**
   - Update incident: "Rolled back to previous version. Service restored. Investigating root cause."

#### Communication

- [ ] Immediate: Slack #taskflow-incidents — "Rollback initiated for {version}"
- [ ] After rollback: Slack #taskflow-incidents — "Rollback complete, service restored"
- [ ] Update status page throughout
- [ ] Schedule post-mortem within 48 hours

---

## 5. Disaster Recovery Runbooks

### RB-011: Database Point-in-Time Recovery

> **Category**: Disaster Recovery
> **Trigger**: Database corruption detected, accidental data deletion, or need to recover to a specific point in time
> **Severity**: P1 — Critical
> **RPO Target**: 1 hour (from env-spec-final.md) 🔶 ASSUMED
> **RTO Target**: 30 minutes (from env-spec-final.md) 🔶 ASSUMED
> **Estimated Recovery Time**: 20-40 minutes
> **Owner**: DBA / SRE Lead
> **Last Tested**: Not yet tested
> **Confidence**: ❓ UNCLEAR

#### Prerequisites

- AWS CLI with RDS admin permissions
- Knowledge of the target recovery time (when was the data valid?)
- Confirmation from Engineering Manager to proceed (data loss implications)

#### Recovery Steps

1. **Assess the situation and identify recovery target**
   ```
   # Check current database status
   aws rds describe-db-instances \
     --db-instance-identifier taskflow-prod \
     --query 'DBInstances[0].{status:DBInstanceStatus,latestRestore:LatestRestorableTime}' \
     --output table
   ```
   - Determine: What time should we recover to? (before the corruption/deletion)
   - Confirm: LatestRestorableTime is after your target time

2. **Notify stakeholders**
   - Update status page: "Database recovery in progress. Service may be unavailable for ~30 minutes."
   - Slack #taskflow-incidents: "Initiating database PITR to {target_time}. ETA: 30 minutes."

3. **Create point-in-time restore**
   ```
   aws rds restore-db-instance-to-point-in-time \
     --source-db-instance-identifier taskflow-prod \
     --target-db-instance-identifier taskflow-prod-pitr-$(date +%Y%m%d%H%M) \
     --restore-time {TARGET_ISO_TIMESTAMP} \
     --db-instance-class db.t3.medium \
     --db-subnet-group-name taskflow-prod-subnet \
     --vpc-security-group-ids sg-xxxxx \
     --multi-az \
     --tags Key=Purpose,Value=pitr-recovery
   ```
   - Wait: ~15-25 minutes for restore to complete
   - Monitor progress:
     ```
     watch -n 30 "aws rds describe-db-instances \
       --db-instance-identifier taskflow-prod-pitr-$(date +%Y%m%d%H%M) \
       --query 'DBInstances[0].DBInstanceStatus' --output text"
     ```

4. **Validate recovered data**
   ```
   psql -h taskflow-prod-pitr-{timestamp}.xxxxx.us-east-1.rds.amazonaws.com -U taskflow_admin -d taskflow -c "
     SELECT 'users' AS tbl, count(*) FROM users
     UNION ALL SELECT 'tasks', count(*) FROM tasks
     UNION ALL SELECT 'projects', count(*) FROM projects;
   "
   ```
   - Compare with expected counts
   - Verify the corrupt/deleted data is restored correctly

5. **Update application configuration to use new database**
   ```
   # Update the database endpoint in Secrets Manager
   aws secretsmanager update-secret \
     --secret-id taskflow/prod/database-url \
     --secret-string "postgresql://taskflow_app:PASSWORD@taskflow-prod-pitr-{timestamp}.xxxxx.us-east-1.rds.amazonaws.com:5432/taskflow"
   ```

6. **Restart application to pick up new config**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --force-new-deployment

   aws ecs update-service \
     --cluster taskflow-prod \
     --service worker \
     --force-new-deployment
   ```
   - Wait: ~3-5 minutes for rolling restart

#### Data Validation

1. **Run full data integrity check**
   ```
   psql -h {NEW_DB_ENDPOINT} -U taskflow_admin -d taskflow -c "
     -- Check referential integrity
     SELECT 'orphan_tasks' AS check_name, count(*)
     FROM tasks t LEFT JOIN projects p ON t.project_id = p.id
     WHERE p.id IS NULL
     UNION ALL
     SELECT 'orphan_assignments', count(*)
     FROM task_assignments ta LEFT JOIN users u ON ta.user_id = u.id
     WHERE u.id IS NULL;
   "
   ```
   - Expected: Zero orphan records

2. **Test application functionality end-to-end**
   ```
   curl -s https://api.taskflow.example.com/health | jq '.'
   curl -s https://api.taskflow.example.com/api/tasks?limit=5 \
     -H "Authorization: Bearer $TEST_TOKEN" | jq '.data | length'
   ```
   - Expected: Health check passes, API returns data

#### Service Restoration

1. **Verify all services are healthy**
   ```
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server worker \
     --query 'services[*].{name:serviceName,running:runningCount,desired:desiredCount}' \
     --output table
   ```

2. **Update status page** — "Database recovery complete. Service fully restored."

#### Post-Recovery

- [ ] Update status page — resolved
- [ ] Rename old database instance (do not delete yet — keep for investigation)
  ```
  aws rds modify-db-instance \
    --db-instance-identifier taskflow-prod \
    --new-db-instance-identifier taskflow-prod-pre-pitr-$(date +%Y%m%d) \
    --apply-immediately
  ```
- [ ] Rename recovered instance to standard name
- [ ] Document timeline: when was the data issue introduced, when was it detected, when was recovery initiated
- [ ] Schedule post-mortem within 48 hours
- [ ] File ticket for root cause prevention

---

### RB-012: Full Service Recovery

> **Category**: Disaster Recovery
> **Trigger**: Complete service outage — multiple services down, or infrastructure-level failure
> **Severity**: P1 — Critical
> **RPO Target**: 1 hour 🔶 ASSUMED
> **RTO Target**: 30 minutes 🔶 ASSUMED
> **Estimated Recovery Time**: 30-60 minutes
> **Owner**: SRE Lead / Engineering Manager
> **Last Tested**: Not yet tested
> **Confidence**: ❓ UNCLEAR

#### Prerequisites

- AWS CLI with admin permissions for ECS, RDS, ElastiCache, ALB
- Access to all infrastructure accounts
- Incident commander designated (Engineering Manager or SRE Lead)

#### Recovery Steps

Recovery MUST follow dependency order: Data Layer -> Application Layer -> Edge Layer.

1. **Assess the situation**
   ```
   # Check all services
   aws ecs describe-services \
     --cluster taskflow-prod \
     --services api-server worker \
     --query 'services[*].{name:serviceName,status:status,running:runningCount,desired:desiredCount}' \
     --output table

   # Check RDS
   aws rds describe-db-instances \
     --db-instance-identifier taskflow-prod \
     --query 'DBInstances[0].{status:DBInstanceStatus,az:AvailabilityZone,multiAZ:MultiAZ}' \
     --output table

   # Check ElastiCache
   aws elasticache describe-cache-clusters \
     --cache-cluster-id taskflow-prod-redis \
     --query 'CacheClusters[0].{status:CacheClusterStatus,nodes:NumCacheNodes}' \
     --output table

   # Check ALB
   aws elbv2 describe-target-health \
     --target-group-arn arn:aws:elasticloadbalancing:us-east-1:123456789:targetgroup/taskflow-api/xxxxx \
     --query 'TargetHealthDescriptions[*].{target:Target.Id,health:TargetHealth.State}' \
     --output table
   ```

2. **Notify stakeholders**
   - Update status page: "Major service outage. Recovery in progress. ETA: 30-60 minutes."
   - Slack #taskflow-incidents: "Full service recovery initiated. Incident commander: {name}"
   - PagerDuty: Ensure all responders are engaged

3. **Step 1: Recover Data Layer — RDS PostgreSQL**
   ```
   # If RDS instance is in error state, check events
   aws rds describe-events \
     --source-identifier taskflow-prod \
     --source-type db-instance \
     --duration 60
   ```
   - If instance is recoverable: wait for AWS auto-recovery or reboot
     ```
     aws rds reboot-db-instance --db-instance-identifier taskflow-prod
     ```
   - If instance is not recoverable: execute RB-011 (Database PITR)
   - Wait for status = "available":
     ```
     aws rds wait db-instance-available --db-instance-identifier taskflow-prod
     ```

4. **Step 2: Recover Data Layer — ElastiCache Redis**
   ```
   # Check Redis status
   aws elasticache describe-cache-clusters \
     --cache-cluster-id taskflow-prod-redis \
     --show-cache-node-info \
     --query 'CacheClusters[0].CacheNodes[*].{id:CacheNodeId,status:CacheNodeStatus}' \
     --output table
   ```
   - If node is in error state: reboot
     ```
     aws elasticache reboot-cache-cluster \
       --cache-cluster-id taskflow-prod-redis \
       --cache-node-ids-to-reboot 0001
     ```
   - Wait: ~5 minutes for reboot
   - Note: Cache will be cold after reboot — expect higher latency initially

5. **Step 3: Recover Application Layer — ECS API Server**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service api-server \
     --desired-count 2 \
     --force-new-deployment
   ```
   - Wait: ~3-5 minutes for tasks to start and pass health checks
   - Verify:
     ```
     aws ecs describe-services \
       --cluster taskflow-prod \
       --services api-server \
       --query 'services[0].{running:runningCount,desired:desiredCount}' \
       --output table
     ```

6. **Step 4: Recover Application Layer — ECS Workers**
   ```
   aws ecs update-service \
     --cluster taskflow-prod \
     --service worker \
     --desired-count 1 \
     --force-new-deployment
   ```
   - Wait: ~3 minutes

7. **Step 5: Verify ALB Health**
   ```
   aws elbv2 describe-target-health \
     --target-group-arn arn:aws:elasticloadbalancing:us-east-1:123456789:targetgroup/taskflow-api/xxxxx \
     --query 'TargetHealthDescriptions[*].{target:Target.Id,health:TargetHealth.State}' \
     --output table
   ```
   - Expected: All targets "healthy"

8. **Step 6: Verify Edge Layer**
   ```
   # Check CloudFront distribution
   aws cloudfront get-distribution \
     --id EXXXXX \
     --query 'Distribution.{status:Status,domainName:DomainName}' \
     --output table

   # Check Route 53 health checks
   aws route53 get-health-check-status \
     --health-check-id xxxxx \
     --query 'HealthCheckObservations[*].{region:Region,status:StatusReport.Status}' \
     --output table
   ```

#### Data Validation

1. **Verify database connectivity from application**
   ```
   curl -s https://api.taskflow.example.com/health | jq '.checks.database'
   ```
   - Expected: "ok" or "connected"

2. **Verify Redis connectivity**
   ```
   curl -s https://api.taskflow.example.com/health | jq '.checks.cache'
   ```
   - Expected: "ok" or "connected"

3. **Test core user flows**
   ```
   curl -s -X GET https://api.taskflow.example.com/api/tasks?limit=5 \
     -H "Authorization: Bearer $TEST_TOKEN" | jq '.data | length'
   ```
   - Expected: Returns task data

#### Service Restoration

1. **Restore traffic**
   - If traffic was diverted or drained: restore normal routing
   - If maintenance page was enabled: disable it

2. **Update status page** — "All services restored. Monitoring for stability."

3. **Monitor for 30 minutes** before declaring recovery complete

#### Post-Recovery

- [ ] Update status page — "Incident resolved"
- [ ] Final Slack update with timeline and summary
- [ ] Document: failure start time, detection time, recovery start, recovery complete, total downtime
- [ ] Schedule post-mortem within 24 hours (P1 requires faster follow-up)
- [ ] File tickets for preventive measures

---

## 6. Runbook Testing Schedule

### Testing Calendar

| Runbook ID | Title | Category | Method | Frequency | Next Test | Environment | Responsible |
|-----------|-------|----------|--------|-----------|-----------|-------------|-------------|
| RB-001 | API Error Rate High | Alert Response | Tabletop | Quarterly | 2026-Q3 | N/A | Backend Team |
| RB-002 | API Latency High | Alert Response | Tabletop | Quarterly | 2026-Q3 | N/A | Backend Team |
| RB-003 | DB Connection Pool Exhaustion | Alert Response | Tabletop | Quarterly | 2026-Q3 | N/A | DBA / SRE |
| RB-004 | Redis Memory High | Alert Response | Tabletop | Quarterly | 2026-Q3 | N/A | Backend Team |
| RB-005 | ECS Task Count Zero | Alert Response | Live Drill | Quarterly | 2026-Q3 | Staging | SRE |
| RB-006 | SSL Certificate Expiring | Alert Response | Tabletop | Bi-annually | 2026-Q4 | N/A | SRE |
| RB-007 | Database Backup Verification | Routine Ops | Execute | Monthly | 2026-05-04 | Staging | DBA |
| RB-008 | Dependency Security Update | Routine Ops | Execute | Weekly | 2026-04-08 | Dev + Staging | Backend Team |
| RB-009 | Standard Deployment | Deployment | Live Drill | Monthly (normal deploys) | Next release | Staging + Prod | Release Manager |
| RB-010 | Emergency Rollback | Deployment | Live Drill | Quarterly | 2026-Q3 | Staging | SRE |
| RB-011 | Database PITR | Disaster Recovery | Live Drill | Quarterly | 2026-Q3 | Staging | DBA / SRE Lead |
| RB-012 | Full Service Recovery | Disaster Recovery | Tabletop + Live Drill | Quarterly | 2026-Q3 | Staging | SRE Lead |

### Testing Procedures

**Tabletop Drill**
1. Assemble the on-call team (30-minute meeting)
2. Present the failure scenario verbally
3. Walk through the runbook step by step — no execution
4. Verify commands are syntactically correct and URLs are valid
5. Record any issues, missing steps, or outdated information
6. Update the runbook immediately after the drill

**Live Fire Drill**
1. Schedule maintenance window in staging environment
2. Inject the failure condition (stop tasks, exhaust connections, etc.)
3. Execute the runbook from start to finish
4. Record time-to-complete and any deviations from documented steps
5. Compare actual vs documented outcomes at each step
6. Update the runbook with corrections and improved time estimates

### Test Results Log

| Date | Runbook | Method | Result | Time | Issues Found | Updated? |
|------|---------|--------|--------|------|-------------|----------|
| — | — | — | — | — | No tests conducted yet | — |

---

## 7. Q&A Log

| ID | Question | Raised By | Priority | Answer | Status | Confidence |
|----|----------|-----------|----------|--------|--------|------------|
| Q-001 | What are the exact Datadog dashboard URLs for TaskFlow? Placeholders used throughout. | AI | HIGH | Pending — need actual Datadog org URLs once monitoring is deployed | Open | ❓ UNCLEAR |
| Q-002 | What is the RDS read-only user password and connection procedure? Assumed `taskflow_readonly` user exists. | AI | HIGH | Pending — need DBA to confirm user setup and access method | Open | 🔶 ASSUMED |
| Q-003 | Are there database migration runbooks needed beyond standard deploy? Some projects require separate migration windows. | AI | MED | Pending — depends on migration complexity and downtime requirements | Open | 🔶 ASSUMED |

---

## 8. Readiness Assessment

### Confidence Summary

| Level | Count | Percentage |
|-------|-------|------------|
| ✅ CONFIRMED | 0 | 0% |
| 🔶 ASSUMED | 10 | 83% |
| ❓ UNCLEAR | 2 | 17% |
| **Total Items** | 12 | 100% |

### Alert Coverage

| Metric | Value |
|--------|-------|
| Total alerts in monitoring plan | 6 (assumed from typical TaskFlow monitoring) |
| Alerts with runbooks | 6 |
| Coverage | 100% |

### Verdict: PARTIALLY READY

The runbook set provides comprehensive coverage across all four categories (alert response, routine ops, deployment, DR) with 12 runbooks total. However:

- **No runbooks have been tested** — all "Last Tested" dates are empty. Until at least the P1 runbooks (RB-003, RB-005, RB-010, RB-011, RB-012) are tested through live drills, the runbooks cannot be considered production-ready.
- **Dashboard URLs are placeholders** — actual Datadog URLs need to be filled in once monitoring is deployed (Q-001).
- **Database access details assumed** — read-only user and connection procedure need DBA confirmation (Q-002).
- **DR runbooks are UNCLEAR** — RB-011 and RB-012 have not been validated against actual infrastructure and contain assumed endpoint names and ARNs.

### Key Risks

| # | Risk | Impact | Mitigation |
|---|------|--------|------------|
| 1 | Untested runbooks may have incorrect commands or missing steps | On-call engineer cannot resolve incident, extended MTTR | Schedule initial fire drills for all P1 runbooks within 30 days |
| 2 | Placeholder URLs mean diagnosis steps require extra time | Slower diagnosis, longer MTTR | Fill in actual URLs immediately after monitoring deployment |
| 3 | DR runbooks unvalidated against real infrastructure | Recovery may fail or take longer than RTO target | Conduct quarterly DR drill in staging before go-live |

---

## 9. Approval

| Role | Name | Decision | Date | Signature |
|------|------|----------|------|-----------|
| SRE / Ops Lead | _________ | Approved / Rejected / Conditional | _________ | _________ |
| Technical Lead | _________ | Approved / Rejected / Conditional | _________ | _________ |
| Engineering Manager | _________ | Approved / Rejected / Conditional | _________ | _________ |

**Conditions / Comments:**
All P1 runbooks (RB-003, RB-005, RB-010, RB-011, RB-012) should be tested through at least a tabletop drill before production launch. DR runbooks (RB-011, RB-012) should have a live drill in staging within 30 days.
