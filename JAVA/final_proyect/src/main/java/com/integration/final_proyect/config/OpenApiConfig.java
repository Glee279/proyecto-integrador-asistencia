package com.integration.final_proyect.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {

        return new OpenAPI()
            .info(new Info()
                .title("API Asistencia - Proyecto Final")
                .version("1.0")
                .description("Sistema de control de asistencia con QR, reportes y justificaciones")
            )
            .addSecurityItem(new SecurityRequirement().addList("BearerAuth"))
            .components(
                new io.swagger.v3.oas.models.Components()
                    .addSecuritySchemes("BearerAuth",
                        new SecurityScheme()
                            .name("Authorization")
                            .type(SecurityScheme.Type.HTTP)
                            .scheme("bearer")
                            .bearerFormat("JWT")
                    )
            );
    }
}
