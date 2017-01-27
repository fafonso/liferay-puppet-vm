DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000"

CATALINA_OPTS="$CATALINA_OPTS $DEBUG_OPTS -Dfile.encoding=UTF8 -Djava.net.preferIPv4Stack=true  -Dorg.apache.catalina.loader.WebappClassLoader.ENABLE_CLEAR_REFERENCES=false -Duser.timezone=GMT -Xmx1024m -XX:MaxPermSize=384m"
