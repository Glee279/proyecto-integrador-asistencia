package com.integration.final_proyect.config;

import java.io.IOException;
import java.util.List;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import com.integration.final_proyect.Jwt.JwtUtil;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;

    public JwtAuthenticationFilter(JwtUtil jwtUtil) {
        this.jwtUtil = jwtUtil;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain chain) throws ServletException, IOException {

        String path = request.getServletPath();

        // Excluyendo login y logout
        if (path.equals("/auth/login") || path.equals("/auth/logout")) {
            chain.doFilter(request, response);
            return;
        }

        String authHeader = request.getHeader("Authorization");
        String token = null;

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        }

        if (token != null) {
            try {
                String username = jwtUtil.getUsername(token);
                List<String> roles = jwtUtil.getRoles(token);

                var authorities = roles.stream()
                        .map(r -> r.startsWith("ROLE_") ? r : "ROLE_" + r)
                        .map(org.springframework.security.core.authority.SimpleGrantedAuthority::new)
                        .toList();

                if (jwtUtil.validateToken(token, username)) {

                    Long idUsuario = jwtUtil.getIdUsuario(token);

                    // principal=username para que getName() funcione (ASISTENCIA)
                    var auth = new UsernamePasswordAuthenticationToken(username, null, authorities);

                    // details=idUsuario para leerlo en endpoints (JUSTIFICACIONES, etc.)
                    auth.setDetails(idUsuario);

                    SecurityContextHolder.getContext().setAuthentication(auth);

                } else {
                    SecurityContextHolder.clearContext();
                }

            } catch (Exception e) {
                SecurityContextHolder.clearContext();
                System.err.println("JWT Error: " + e.getMessage());
            }
        }

        chain.doFilter(request, response);
    }
}
