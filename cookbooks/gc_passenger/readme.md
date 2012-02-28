# GC Tuning for Passenger

Creates a wrapper script for ruby in /usr/local/bin/ruby_wrapper and updates the nginx config to use this wrapper instead of the default ruby.

Garbage collection tweaks can then be made inside of the wrapper.