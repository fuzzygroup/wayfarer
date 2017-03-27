#!/usr/bin/env bash
../bin/wayfarer enqueue integration.rb https://en.wikipedia.org/wiki/Special:Random --queue_adapter sidekiq
