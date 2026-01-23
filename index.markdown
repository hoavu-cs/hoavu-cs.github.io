---
title: Contents
nav_order: 1
layout: default
permalink: /
---

This is my personal archive. It contains notes and code from my teaching, research, and non-academic projects.
Hope you find it useful!

My academic homepage is [here](https://www.hoavu.org/).


## Contents

**Data Structures and Algorithms**
<ul>

{% assign dsa_pages = site.pages | where: "parent", "DSA" | sort: "nav_order" %}
{% for page in dsa_pages %}
  <li>
    <a href="{{ page.url }}">{{ page.title }}</a>
  </li>
{% endfor %}
</ul>

