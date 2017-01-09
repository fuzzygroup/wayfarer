---
layout: default
title: Contributing
---

# Contributing

1. Fork the repository
2. Ensure the development dependencies are installed:
    `% bundle install --with development`
2. Make changes
3. Ensure your (new?) tests pass:
  `% bundle exec rake test`
4. Appease Rubocop:
  `% bundle exec rake rubocop:auto_correct`
5. Fix Rubocop's offenses or have a good excuse not to:
  `% bundle exec rake rake rubocop`
6. Write a good commit message
7. Open a pull request on GitHub
8. Thank you
