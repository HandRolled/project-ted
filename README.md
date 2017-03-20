

To list top 100 words (excluding stop words):

```
MATCH (w:Word)-[:APPEARED_IN]->(t:Talk)
WHERE NOT EXISTS(w.is_stop_word)
WITH w, count(t) as rels
RETURN w.normalized_text AS text, rels AS appearances
ORDER BY rels DESC
LIMIT 100
```
