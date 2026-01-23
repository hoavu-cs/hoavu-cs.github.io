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

<ul>
  <li><strong>DSA</strong>
    <ul>
      {% for page in site.pages %}
        {% if page.parent == "DSA" %}
          <li>
            <a href="{{ page.url }}">{{ page.title }}</a>
          </li>
        {% endif %}
      {% endfor %}
    </ul>
  </li>
</ul>
