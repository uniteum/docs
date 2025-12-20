---
title: References
description: External research, protocols, and resources related to Uniteum
parent: Reference
nav_order: 5

# Metadata
last_updated: 2024-12-19
---

# References

External research papers, articles, and resources that provide context for understanding Uniteum's mechanisms and design philosophy.

---

## Research

{% for ref in site.data.references.research %}
### {{ ref.title }}

**Authors:** {{ ref.authors }}
**Published:** {{ ref.date }} — {{ ref.publisher }}

{{ ref.description }}

**Relevance to Uniteum:** {{ ref.relevance }}

[Read the article →]({{ ref.url }}){: .btn .btn-primary }

---
{% endfor %}

## Related Protocols

{% if site.data.references.protocols %}
{% for ref in site.data.references.protocols %}
### {{ ref.name }}

{{ ref.description }}

{% if ref.resources %}
**Resources:**
{% for resource in ref.resources %}
- [{{ resource[0] | capitalize }}]({{ resource[1] }})
{% endfor %}
{% endif %}

{% if ref.relevance %}
**Relevance:** {{ ref.relevance }}
{% endif %}

---
{% endfor %}
{% else %}
*No protocol references yet.*
{% endif %}

## Technical Resources

{% if site.data.references.technical %}
{% for ref in site.data.references.technical %}
- [**{{ ref.name }}**]({{ ref.url }}) — {{ ref.description }}
{% endfor %}
{% else %}
*No technical references yet.*
{% endif %}

---

## Contributing References

Found a relevant research paper, protocol, or resource? Please [open an issue](https://github.com/{{ site.repository }}/issues) or submit a pull request to add it to [`_data/references.yml`](https://github.com/{{ site.repository }}/blob/main/_data/references.yml).
