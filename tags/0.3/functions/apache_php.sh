# -------------------------------------------------------
# ---------------- Apache & PHP -------------------------
# -------------------------------------------------------

apache_php_config()
{
    backup_file ${HTTPD_CONF}

    # --------------------------
    # Apache Setting.
    # --------------------------
    ECHO_INFO "Hide apache software version: ${HTTPD_CONF}."
    perl -pi -e 's#^(ServerTokens).*#${1} ProductOnly#' ${HTTPD_CONF}
    perl -pi -e 's#^(ServerSignature).*#${1} EMail#' ${HTTPD_CONF}

    ECHO_INFO "Disable 'AddDefaultCharset' in Apache: ${HTTPD_CONF}."
    perl -pi -e 's/^(AddDefaultCharset UTF-8)/#${1}/' ${HTTPD_CONF}

    if [ X"${HTTPD_PORT}" != X"80" ]; then
        ECHO_INFO "Change Apache listen port to: ${HTTPD_PORT}."
        perl -pi -e 's#^(Listen )(80)$#${1}$ENV{HTTPD_PORT}#' ${HTTPD_CONF}
    else
        :
    fi

    # --------------------------
    # PHP Setting.
    # --------------------------
    backup_file ${PHP_INI}

    ECHO_INFO "Hide PHP Version in Apache from remote users requests: ${PHP_INI}."
    perl -pi -e 's#^(expose_php.*=)#${1} Off;#' ${PHP_INI}

    ECHO_INFO "Increase 'memory_limit' to 128M: ${PHP_INI}."
    perl -pi -e 's#^(memory_limit = )#${1} 128M;#' ${PHP_INI}

    ECHO_INFO "Increase 'upload_max_filesize', 'post_max_size' to 10/12M: ${PHP_INI}."
    perl -pi -e 's/^(upload_max_filesize.*=)/${1}10M; #/' ${PHP_INI}
    perl -pi -e 's/^(post_max_size.*=)/${1}12M; #/' ${PHP_INI}

    cat >> ${TIP_FILE} <<EOF
Apache & PHP:
    * Configuration files:
        - /etc/httpd/conf/
        - /etc/httpd/conf.d/
        - /etc/php.ini
    * Directories:
        - ${HTTPD_SERVERROOT}
        - ${HTTPD_DOCUMENTROOT}

EOF

    echo 'export status_apache_php_config="DONE"' >> ${STATUS_FILE}
}