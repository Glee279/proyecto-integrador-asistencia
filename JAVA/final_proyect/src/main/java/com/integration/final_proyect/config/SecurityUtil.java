package com.integration.final_proyect.config;

import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtil {

    private SecurityUtil() {}

    public static Long getIdUsuarioAutenticado() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null) return null;

        Object details = auth.getDetails();
        if (details instanceof Long) return (Long) details;
        if (details instanceof Integer) return ((Integer) details).longValue();

        return null;
    }
}
