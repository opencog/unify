
# Bogus boilerplate for unit-testing. This should be automated.
WRITE_GUILE_CONFIG(
	${GUILE_BIN_DIR}/opencog/unify-config.scm
	SCM_CONFIG TRUE
)

WRITE_GUILE_CONFIG(
	${GUILE_BIN_DIR}/opencog/unify-config-installable.scm
	SCM_CONFIG FALSE
)

INSTALL(
	FILES ${GUILE_BIN_DIR}/opencog/unify-config-installable.scm
	DESTINATION ${GUILE_SITE_DIR}/opencog
	RENAME unify-config.scm
)

ADD_GUILE_MODULE (FILES
	unify.scm
	MODULE_DESTINATION "${GUILE_SITE_DIR}/opencog/unify"
)
