# 📊 SQL Sample: Campaign & Email Analytics

This short SQL sample showcases my ability to query a normalized schema for actionable insights, while emphasizing performance, clarity, and real-world applicability.

---

## 🧱 Schema Overview

```

users(id, name)
campaigns(id, name, owner\_id → users.id)
emails(id, campaign\_id → campaigns.id, recipient, opened\_at, bounced)

````

---

## 🔍 Queries & What They Demonstrate

### 1. 📈 Open Rate Per Campaign

```sql
SELECT
  c.id AS campaign_id,
  c.name AS campaign_name,
  COUNT(e.id) AS total_emails,
  COUNT(e.opened_at) AS opened_emails,
  ROUND(COUNT(e.opened_at) * 100.0 / NULLIF(COUNT(e.id), 0), 2) AS open_rate_percentage
FROM
  campaigns c
JOIN
  emails e ON c.id = e.campaign_id
WHERE
  e.bounced = FALSE
GROUP BY
  c.id, c.name
ORDER BY
  open_rate_percentage DESC;
````

✅ Highlights:

* Uses `NULLIF` to avoid division by zero
* Filters out bounced emails for accurate open rate
* Prioritizes clarity for business intelligence use

---

### 2. 🏆 Top 5 Campaign Owners by Email Volume

```sql
SELECT 
  u.id AS user_id,
  u.name,
  COUNT(e.id) AS sent_emails
FROM 
  users u
JOIN 
  campaigns c ON c.owner_id = u.id
JOIN 
  emails e ON e.campaign_id = c.id
GROUP BY 
  u.id, u.name
ORDER BY 
  sent_emails DESC
LIMIT 5;
```

✅ Highlights:

* Tracks outbound volume at the **owner level**
* Uses explicit `JOIN`s and grouping for clarity and performance
* Adjusted for PostgreSQL/MySQL syntax with `LIMIT`

---

### 3. 🚫 Bounce Rate by Campaign Owner

```sql
SELECT 
  u.id AS user_id,
  u.name,
  COUNT(*) AS total_emails,
  SUM(CASE WHEN e.bounced THEN 1 ELSE 0 END) AS bounced_emails,
  ROUND(SUM(CASE WHEN e.bounced THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS bounce_rate_percentage
FROM 
  users u
JOIN 
  campaigns c ON c.owner_id = u.id
JOIN 
  emails e ON e.campaign_id = c.id
GROUP BY 
  u.id, u.name
ORDER BY 
  bounce_rate_percentage DESC;
```

✅ Highlights:

* Uses conditional aggregation for bounce tracking
* Demonstrates safe division and grouping across joins
* Offers meaningful team-level diagnostics

---

## 💡 Why This Sample

These queries reflect how I think about:

* **Business context** → targeting owners, not just recipients
* **Schema understanding** → proper joins, ownership vs. recipient logic
* **Query performance** → aggregate operations with safe guards (`NULLIF`, `CASE`)
* **Clarity & maintainability** → readable aliases and separation of concerns