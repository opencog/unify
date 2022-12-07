# Bogus boilerplate for unit-testing. This should be automated.
# This must come first, befoe any other build targets.
DECLARE_GUILE_CONFIG_TARGET(SCM_CONFIG "opencog unify-config" "UNIFY_TEST")

# Dirs listed in dependency order.  No matter, cmake overrides.
ADD_SUBDIRECTORY (unify)
ADD_SUBDIRECTORY (types)
ADD_SUBDIRECTORY (atoms)
ADD_SUBDIRECTORY (scm)
