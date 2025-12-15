package com.integration.final_proyect.Jwt;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

@Component
public class JwtUtil {

    @Value("${jwt.secret}")
    private String SECRET;

    public String generateToken(String username, Long idUsuario, List<String> roles, String modalidad) {
        return JWT.create()
                .withSubject(username)
                .withClaim("idUsuario", idUsuario)
                .withClaim("roles", roles)
                .withClaim("modalidad", modalidad)
                .withIssuedAt(new Date())
                .withExpiresAt(new Date(System.currentTimeMillis() + 60 * 60 * 1000))
                .sign(Algorithm.HMAC256(SECRET));
    }

    public boolean validateToken(String token, String username) {
        DecodedJWT jwt = decode(token);
        return jwt.getSubject().equals(username) && jwt.getExpiresAt().after(new Date());
    }

    public String getUsername(String token) {
        return decode(token).getSubject();
    }

    public List<String> getRoles(String token) {
        return decode(token).getClaim("roles").asList(String.class);
    }

    public Long getIdUsuario(String token) {
        return decode(token).getClaim("idUsuario").asLong();
    }

    private DecodedJWT decode(String token) {
        JWTVerifier verifier = JWT.require(Algorithm.HMAC256(SECRET)).build();
        return verifier.verify(token);
    }
}
