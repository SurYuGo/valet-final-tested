# Gunakan JDK 17 (yang kompatibel dengan Spring Boot modern)
FROM eclipse-temurin:17-jdk
# Buat folder aplikasi
WORKDIR /app
# Copy WAR hasil build
COPY target/valet-final-tested.war app.war
# Expose port 8080 (wajib untuk Render)
EXPOSE 8080
# Jalankan WAR seperti JAR
ENTRYPOINT ["java", "-jar", "/app/app.war"]
