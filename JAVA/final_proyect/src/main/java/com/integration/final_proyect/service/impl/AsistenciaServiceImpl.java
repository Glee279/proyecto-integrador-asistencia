package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Types;
import java.util.List;

import org.hibernate.Session;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.asistencia.AsistenciaCheckInRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaCheckOutRequestDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaEstadoDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaHistorialResponseDTO;
import com.integration.final_proyect.dto.asistencia.AsistenciaResponseDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.models.Asistencia;
import com.integration.final_proyect.models.Usuario;
import com.integration.final_proyect.repository.AsistenciaRepository;
import com.integration.final_proyect.repository.UsuarioRepository;
import com.integration.final_proyect.service.AsistenciaService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Service
public class AsistenciaServiceImpl implements AsistenciaService {

        @PersistenceContext
        private EntityManager entityManager;

        private final AsistenciaRepository asistenciaRepository;
        private final UsuarioRepository usuarioRepository;

        public AsistenciaServiceImpl(AsistenciaRepository asistenciaRepository, UsuarioRepository usuarioRepository) {
                this.asistenciaRepository = asistenciaRepository;
                this.usuarioRepository = usuarioRepository;
        }

        @Override
        @Transactional
        public AsistenciaResponseDTO checkIn(AsistenciaCheckInRequestDTO dto) {

                Usuario usuario = obtenerUsuarioAutenticado();

                validarModalidad(usuario, dto.getTipo());

                if ("MANUAL".equalsIgnoreCase(dto.getTipo())) {
                        return ejecutarCheckInManual(usuario.getIdUsuario());
                }

                if ("QR".equalsIgnoreCase(dto.getTipo())) {

                        if (dto.getCodigoQr() == null || dto.getCodigoQr().isBlank()) {
                                throw new ValidatedRequestException("Código QR obligatorio");
                        }

                        return ejecutarCheckInQr(usuario.getIdUsuario(), dto.getCodigoQr());
                }

                throw new ValidatedRequestException("Tipo no válido");
        }

        @Override
        @Transactional
        public AsistenciaResponseDTO checkOut(AsistenciaCheckOutRequestDTO dto) {

                Usuario usuario = obtenerUsuarioAutenticado();

                if ("MANUAL".equalsIgnoreCase(dto.getTipo())) {
                        return ejecutarCheckOutManual(usuario.getIdUsuario());
                }

                if ("QR".equalsIgnoreCase(dto.getTipo())) {

                        if (dto.getCodigoQr() == null || dto.getCodigoQr().isBlank()) {
                                throw new ValidatedRequestException("Código QR obligatorio");
                        }

                        return ejecutarCheckOutQr(usuario.getIdUsuario(), dto.getCodigoQr());
                }

                throw new ValidatedRequestException("Tipo no válido");
        }

        @Override
        public List<AsistenciaHistorialResponseDTO> historial() {

                Usuario usuario = obtenerUsuarioAutenticado();

                return asistenciaRepository.historialPorUsuario(usuario.getIdUsuario());
        }

        private Usuario obtenerUsuarioAutenticado() {

                String username = SecurityContextHolder.getContext()
                                .getAuthentication()
                                .getName();

                return usuarioRepository.findByUsuario(username)
                                .orElseThrow(() -> new ValidatedRequestException("Usuario no encontrado"));
        }

        private void validarModalidad(Usuario usuario, String tipo) {

                if ("PRESENCIAL".equalsIgnoreCase(usuario.getModalidad())
                                && "MANUAL".equalsIgnoreCase(tipo)) {

                        throw new ValidatedRequestException(
                                        "Usuario presencial debe registrar asistencia mediante QR");
                }
        }

        private AsistenciaResponseDTO ejecutarCheckInManual(Long idUsuario) {

                return entityManager.unwrap(Session.class)
                                .doReturningWork(conn -> {

                                        String sql = "{ call k_asistencia.p_registrar_entrada_manual(?, ?, ?, ?) }";

                                        try (CallableStatement cs = conn.prepareCall(sql)) {

                                                cs.setLong(1, idUsuario);
                                                cs.registerOutParameter(2, Types.BIGINT); // p_id_asistencia
                                                cs.registerOutParameter(3, Types.INTEGER); // p_cod_result
                                                cs.registerOutParameter(4, Types.VARCHAR); // p_msg_result

                                                cs.execute();

                                                validarResultado(cs.getInt(3), cs.getString(4));
                                                System.out.println("ID ASISTENCIA DEVUELTA: " + cs.getLong(2));
                                                return AsistenciaResponseDTO.builder()
                                                                .idAsistencia(cs.getLong(2))
                                                                .mensaje(cs.getString(4))
                                                                .build();

                                        } catch (SQLException e) {
                                                throw new RuntimeException("Error check-in manual", e);
                                        }
                                });
        }

        private AsistenciaResponseDTO ejecutarCheckInQr(Long idUsuario, String codigoQr) {

                return entityManager.unwrap(Session.class)
                                .doReturningWork(conn -> {

                                        String sql = "{ call k_asistencia.p_registrar_entrada_qr(?, ?, ?, ?, ?) }";

                                        try (CallableStatement cs = conn.prepareCall(sql)) {

                                                cs.setLong(1, idUsuario);
                                                cs.setString(2, codigoQr);
                                                cs.registerOutParameter(3, Types.BIGINT);
                                                cs.registerOutParameter(4, Types.INTEGER);
                                                cs.registerOutParameter(5, Types.VARCHAR);

                                                cs.execute();

                                                validarResultado(cs.getInt(4), cs.getString(5));

                                                return AsistenciaResponseDTO.builder()
                                                                .idAsistencia(cs.getLong(3))
                                                                .mensaje(cs.getString(5))
                                                                .build();

                                        } catch (SQLException e) {
                                                throw new RuntimeException("Error check-in QR", e);
                                        }
                                });
        }

        private AsistenciaResponseDTO ejecutarCheckOutManual(Long idUsuario) {

                return entityManager.unwrap(Session.class)
                                .doReturningWork(conn -> {

                                        String sql = "{ call k_asistencia.p_registrar_salida_manual(?, ?, ?, ?) }";

                                        try (CallableStatement cs = conn.prepareCall(sql)) {

                                                cs.setLong(1, idUsuario);
                                                cs.registerOutParameter(2, Types.BIGINT);
                                                cs.registerOutParameter(3, Types.INTEGER);
                                                cs.registerOutParameter(4, Types.VARCHAR);

                                                cs.execute();

                                                validarResultado(cs.getInt(3), cs.getString(4));

                                                return AsistenciaResponseDTO.builder()
                                                                .idAsistencia(cs.getLong(2))
                                                                .mensaje(cs.getString(4))
                                                                .build();

                                        } catch (SQLException e) {
                                                throw new RuntimeException("Error check-out manual", e);
                                        }
                                });
        }

        private AsistenciaResponseDTO ejecutarCheckOutQr(Long idUsuario, String codigoQr) {

                return entityManager.unwrap(Session.class)
                                .doReturningWork(conn -> {

                                        String sql = "{ call k_asistencia.p_registrar_salida_qr(?, ?, ?, ?, ?) }";

                                        try (CallableStatement cs = conn.prepareCall(sql)) {

                                                cs.setLong(1, idUsuario);
                                                cs.setString(2, codigoQr);
                                                cs.registerOutParameter(3, Types.BIGINT);
                                                cs.registerOutParameter(4, Types.INTEGER);
                                                cs.registerOutParameter(5, Types.VARCHAR);

                                                cs.execute();

                                                validarResultado(cs.getInt(4), cs.getString(5));

                                                return AsistenciaResponseDTO.builder()
                                                                .idAsistencia(cs.getLong(3))
                                                                .mensaje(cs.getString(5))
                                                                .build();

                                        } catch (SQLException e) {
                                                throw new RuntimeException("Error check-out QR", e);
                                        }
                                });
        }

        private void validarResultado(int codigo, String mensaje) {

                if (codigo != 1) {
                        throw new ValidatedRequestException(mensaje);
                }
        }

        @Override
        public AsistenciaEstadoDTO estadoHoy() {

                Usuario usuario = obtenerUsuarioAutenticado();
                Long idUsuario = usuario.getIdUsuario();

                long countEntrada = asistenciaRepository.countCheckInToday(idUsuario);
                boolean tieneEntrada = countEntrada > 0;

                long countSalida = asistenciaRepository.countCheckOutToday(idUsuario);
                boolean tieneSalida = countSalida > 0;

                AsistenciaEstadoDTO estado = new AsistenciaEstadoDTO();
                estado.setTieneEntrada(tieneEntrada);
                estado.setTieneSalida(tieneSalida);

                return estado;
        }

        @Override
        public List<AsistenciaHistorialResponseDTO> historialEmpleado(Date fechaInicio, Date fechaFin) {

                Usuario usuario = obtenerUsuarioAutenticado();

                return asistenciaRepository
                                .historialEmpleado(usuario.getIdUsuario(), fechaInicio, fechaFin)
                                .stream()
                                .map(this::mapToDTO)
                                .toList();
        }

        @Override
        public List<AsistenciaHistorialResponseDTO> historialAdmin(Long idUsuario, Date fechaInicio, Date fechaFin) {

                return asistenciaRepository
                                .historialAdmin(idUsuario, fechaInicio, fechaFin)
                                .stream()
                                .map(this::mapToDTO)
                                .toList();
        }

        private AsistenciaHistorialResponseDTO mapToDTO(Asistencia a) {

                return new AsistenciaHistorialResponseDTO(
                                a.getIdAsistencia(),
                                a.getFecEntrada(),
                                a.getFecSalida(),
                                a.getTipAsistencia(),
                                a.getMcaEstado(),
                                a.getSede() != null ? a.getSede().getNombre() : null);
        }

}
