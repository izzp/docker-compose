# 指定基于的基础镜像
FROM openjdk:11
# 作者
LABEL org.opencontainers.image.authors="ZhaoZhipeng"
COPY *.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app.jar"]