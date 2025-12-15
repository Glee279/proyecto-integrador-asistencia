package com.integration.final_proyect.service.impl;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.List;

import org.springframework.stereotype.Service;

import com.integration.final_proyect.Jwt.JwtUtil;
import com.integration.final_proyect.dto.AuthRequestDTO;
import com.integration.final_proyect.dto.AuthResponseDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.models.Usuario;
import com.integration.final_proyect.models.UsuarioRol;
import com.integration.final_proyect.repository.UsuarioRepository;
import com.integration.final_proyect.repository.UsuarioRolRepository;
import com.integration.final_proyect.service.AuthService;

@Service
public class AuthServiceImpl implements AuthService {

    private final UsuarioRepository usuarioRepository;
    private final UsuarioRolRepository usuarioRolRepository;
    private final JwtUtil jwtUtil;

    public AuthServiceImpl(UsuarioRepository usuarioRepository, UsuarioRolRepository usuarioRolRepository, JwtUtil jwtUtil) {

        this.usuarioRepository = usuarioRepository;
        this.usuarioRolRepository = usuarioRolRepository;
        this.jwtUtil = jwtUtil;
    }

    @Override
    public AuthResponseDTO login(AuthRequestDTO request) {

        String userInput = request.getUsuario().trim();
        String passInput = request.getPassword().trim();

        // 1. Buscar usuario
        Usuario usuario = usuarioRepository.findByUsuario(userInput)
                .orElseThrow(() -> new ValidatedRequestException("Usuario o contraseña incorrectos."));

        // 2. Validar estado
        if (!"A".equals(usuario.getMcaEstado())) {
            throw new ValidatedRequestException("Usuario inactivo");
        }

        // 3. Comparar contraseña usando SHA-512 + SALT (igual que Oracle)
        boolean valida = validarPassword(passInput, usuario.getSaltUsu(), usuario.getPassUsu());

        if (!valida) {
            System.out.println(">>> PASSWORD RECIBIDO RAW: [" + request.getPassword() + "]");
            System.out.println(">>> LENGTH: " + request.getPassword().length());
            for (char c : request.getPassword().toCharArray()) {
                System.out.println("CHAR: " + c + " ASCII: " + (int)c);
            }
            throw new ValidatedRequestException("Usuario o contraseña incorrectos");
        }

        // System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> USUARIO BD: " + usuario.getUsuario());
        // System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> ESTADO: " + usuario.getMcaEstado());
        // System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> SALT: " + usuario.getSaltUsu());
        // System.out.println(">>>>>>>>>>>>>>>>>>>>>>>> HASH DB: " + usuario.getPassUsu());

        // 4. Roles
        List<UsuarioRol> roles = usuarioRolRepository.findByUsuario_IdUsuario(usuario.getIdUsuario());
        List<String> nombresRoles = roles.stream()
                .map(r -> r.getRol().getNombre())
                .toList();

        // System.out.println("USUARIO RECIBIDO: " + request.getUsuario());
        // System.out.println("PASSWORD RECIBIDO: " + request.getPassword());

        // 5. Crear token JWT
        String token = jwtUtil.generateToken(usuario.getUsuario(), usuario.getIdUsuario(), nombresRoles, usuario.getModalidad());

        // 6. Retornar respuesta
        return AuthResponseDTO.builder()
                .token(token)
                .usuario(usuario.getUsuario())
                .idUsuario(usuario.getIdUsuario())
                .roles(nombresRoles)
                .modalidad(usuario.getModalidad())
                .build();
    }

    private boolean validarPassword(String password, String saltHex, String hashStored) {
        try {
            // Oracle: password || SALT_HEX
            String combined = password + saltHex;

            // UTF-8 igual que UTL_I18N.STRING_TO_RAW
            byte[] rawBytes = combined.getBytes(StandardCharsets.UTF_8);

            // SHA-512 igual que DBMS_CRYPTO.HASH_SH512
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            byte[] hashBytes = md.digest(rawBytes);

            // Convertir a HEX mayúsculas igual que RAWTOHEX
            String hashHex = bytesToHex(hashBytes);

            // System.out.println("---------------- DEBUG PASSWORD ORACLE STYLE ----------------");
            // System.out.println("INPUT PASSWORD : " + password);
            // System.out.println("SALT (HEX)     : " + saltHex);
            // System.out.println("COMBINED       : " + combined);
            // System.out.println("GENERATED HEX  : " + hashHex);
            // System.out.println("DB STORED HEX  : " + hashStored);
            // System.out.println("-------------------------------------------------------------");

            // System.out.println("GEN COMBINED STRING: [" + password + saltHex + "]");
            // System.out.println("GEN LENGTH: " + (password + saltHex).length());

            return hashHex.equalsIgnoreCase(hashStored);

        } catch (Exception ex) {
            return false;
        }
    }

    private static String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02X", b)); // siempre mayúsculas
        }
        return sb.toString();
    }

}
