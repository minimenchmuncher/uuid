# UUIDs for R

This is a package for supporting UUIDs in R. Please use with caution, this project is under heavy development.

The main idea is the UUID should be an instance of an S4 class so it better mimics handling of UUIDs in other languages.

## TODO:
- Allow creation of text-only uuids
- ~Create a `show` method~
- Ensure uniqueness while generating lots of UUIDs simultaneously
- Create a function that creates multiple UUIDs simultaneously
- Create a `c()` method
- create `as.character()` or similar
