package com.integration.final_proyect.service.impl;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.Session;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.integration.final_proyect.dto.usuario.CambiarPasswordRequestDTO;
import com.integration.final_proyect.dto.usuario.ResetPasswordResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateRequestDTO;
import com.integration.final_proyect.dto.usuario.UsuarioCreateResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioResponseDTO;
import com.integration.final_proyect.dto.usuario.UsuarioUpdateRequestDTO;
import com.integration.final_proyect.exception.ValidatedRequestException;
import com.integration.final_proyect.service.UsuarioService;

import jakarta.persistence.EntityManager;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.StoredProcedureQuery;
import oracle.jdbc.OracleTypes;

@Service
public class UsuarioServiceImpl implements UsuarioService {

    @PersistenceContext
    private EntityManager entityManager;

    private String obtenerDniPorUsername(String username) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_USUARIO.f_obtener_dni_por_usuario(?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, Types.VARCHAR);
                cs.setString(2, username);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                return cs.getString(1);

            }
        });
    }

    private String obtenerDniPorId(Long idUsuario) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_USUARIO.f_obtener_dni_por_id(?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, Types.VARCHAR);
                cs.setLong(2, idUsuario);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                return cs.getString(1);

            }
        });
    }

    @Override
    @Transactional
    public UsuarioCreateResponseDTO crearUsuario(UsuarioCreateRequestDTO dto) {

        // 1.- Llamar a al procedimiento
        StoredProcedureQuery sp = entityManager
            .createStoredProcedureQuery("K_USUARIO.P_CREAR_USUARIO");

        // 2.- Registrar parámetros de entrada
        sp.registerStoredProcedureParameter("p_mca_estado", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_area", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_hora_ini", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_hora_fin", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_modalidad", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_apel_pat", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_apel_mat", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_pri_nombre", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_seg_nombre", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_dni", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_telefono", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_direccion", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_correo_per", String.class, ParameterMode.IN);
        // 3.- Registrar parámetros de salida
        sp.registerStoredProcedureParameter("p_id_usuario", Long.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_usuario", String.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_pass_usu", String.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_correo_cor", String.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 4.- Seteo de valores
        sp.setParameter("p_mca_estado", "A");
        sp.setParameter("p_area", dto.getArea());
        sp.setParameter("p_hora_ini", dto.getHoraIni());
        sp.setParameter("p_hora_fin", dto.getHoraFin());
        sp.setParameter("p_modalidad", dto.getModalidad());
        sp.setParameter("p_apel_pat", dto.getApelPat());
        sp.setParameter("p_apel_mat", dto.getApelMat());
        sp.setParameter("p_pri_nombre", dto.getPriNombre());
        sp.setParameter("p_seg_nombre", dto.getSegNombre());
        sp.setParameter("p_dni", dto.getDni());
        sp.setParameter("p_telefono", dto.getTelefono());
        sp.setParameter("p_direccion", dto.getDireccion());
        sp.setParameter("p_correo_per", dto.getCorreoPer());

        // 5.- Ejecución del procedimiento
        sp.execute();

        // 6.- Validacion de los resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == 2) {
            throw new RuntimeException(msg);
        }

        // 7.- Construir la repuesta
        return UsuarioCreateResponseDTO.builder()
            .idUsuario((Long) sp.getOutputParameterValue("p_id_usuario"))
            .usuario((String) sp.getOutputParameterValue("p_usuario"))
            .passwordTemporal((String) sp.getOutputParameterValue("p_pass_usu"))
            .correoCor((String) sp.getOutputParameterValue("p_correo_cor"))
            .estado("A")
            .build();

    }

    @Override
    @Transactional
    public UsuarioResponseDTO actualizarUsuario(Long idUsuario, UsuarioUpdateRequestDTO dto) {

        entityManager.unwrap(Session.class).doWork(conn -> {

            String sql = "{ call K_USUARIO.p_actualizar_usuario(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.setLong(1, idUsuario);
                cs.setString(2, dto.getArea());
                cs.setString(3, dto.getHoraIni());
                cs.setString(4, dto.getHoraFin());
                cs.setString(5, dto.getModalidad());
                cs.setString(6, dto.getApelPat());
                cs.setString(7, dto.getApelMat());
                cs.setString(8, dto.getPriNombre());
                cs.setString(9, dto.getSegNombre());
                cs.setString(10, dto.getDni());
                cs.setString(11, dto.getTelefono());
                cs.setString(12, dto.getDireccion());
                cs.setString(13, dto.getCorreoPer());
                cs.setString(14, dto.isRegenerarUsuario() ? "S" : "N");

                cs.registerOutParameter(15, Types.VARCHAR);
                cs.registerOutParameter(16, Types.VARCHAR);
                cs.registerOutParameter(17, Types.INTEGER);
                cs.registerOutParameter(18, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(17);
                String msg = cs.getString(18);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

            } catch (SQLException e) {
                throw new RuntimeException("Error al actualizar usuario", e);
            }
        });

        return obtenerPorId(idUsuario);
    }

    @Override
    @Transactional(readOnly = true)
    public UsuarioResponseDTO obtenerPorId(Long idUsuario) {

        String dni = obtenerDniPorId(idUsuario);

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_USUARIO.f_obtener_usuario(?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.setString(2, dni);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);

                if (!rs.next()) {
                    throw new ValidatedRequestException("Usuario no encontrado");
                }

                UsuarioResponseDTO dto = UsuarioResponseDTO.builder()
                        .idUsuario(rs.getLong("id_usuario"))
                        .dni(rs.getString("dni"))
                        .usuario(rs.getString("usuario"))
                        .nombres(rs.getString("nombres"))
                        .area(rs.getString("area"))
                        .modalidad(rs.getString("modalidad"))
                        .horaIni(rs.getString("hora_ini"))
                        .horaFin(rs.getString("hora_fin"))
                        .telefono(rs.getString("telefono"))
                        .direccion(rs.getString("direccion"))
                        .correoPer(rs.getString("correo_per"))
                        .correoCor(rs.getString("correo_cor"))
                        .estado(rs.getString("mca_estado"))
                        .build();

                rs.close();
                return dto;

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener usuario", e);
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public UsuarioResponseDTO obtenerMiPerfil(String username) {

        String dni = obtenerDniPorUsername(username);

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ ? = call K_USUARIO.f_obtener_usuario(?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.setString(2, dni);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);

                if (!rs.next()) {
                    throw new ValidatedRequestException("Perfil no encontrado");
                }

                UsuarioResponseDTO dto = UsuarioResponseDTO.builder()
                        .idUsuario(rs.getLong("id_usuario"))
                        .dni(rs.getString("dni"))
                        .usuario(rs.getString("usuario"))
                        .nombres(rs.getString("nombres"))
                        .area(rs.getString("area"))
                        .modalidad(rs.getString("modalidad"))
                        .horaIni(rs.getString("hora_ini"))
                        .horaFin(rs.getString("hora_fin"))
                        .telefono(rs.getString("telefono"))
                        .direccion(rs.getString("direccion"))
                        .correoPer(rs.getString("correo_per"))
                        .correoCor(rs.getString("correo_cor"))
                        .estado(rs.getString("mca_estado"))
                        .build();

                rs.close();
                return dto;

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener perfil", e);
            }
        });
    }

    @Override
    @Transactional
    public void cambiarPassword(String username, CambiarPasswordRequestDTO dto) {

        // 1. Obtener ID del usuario autenticado
        Object[] data = entityManager.createQuery(
                "SELECT u.idUsuario, u.usuario FROM Usuario u WHERE u.usuario = :username",
                Object[].class
            )
            .setParameter("username", username)
            .getSingleResult();

        Long idUsuario = ((Number) data[0]).longValue();
        String usuario = (String) data[1];

        // 2. Llamar al procedimiento
        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_actualizar_password");

        // 3. Registrar los parametros
        sp.registerStoredProcedureParameter("p_id_usuario", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_usuario", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_old_password", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_new_password", String.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        // 4. Seteo de valores
        sp.setParameter("p_id_usuario", idUsuario);
        sp.setParameter("p_usuario", usuario);
        sp.setParameter("p_old_password", dto.getPasswordActual());
        sp.setParameter("p_new_password", dto.getPasswordNueva());

        // 5. Ejecucion del procedimiento
        sp.execute();

        // 6.- Validar resultado
        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new RuntimeException(msg != null ? msg : "Error al cambiar contraseña");
        }
    }

    @Override
    @Transactional
    public ResetPasswordResponseDTO resetearPassword(Long idUsuario) {

        return entityManager.unwrap(Session.class).doReturningWork(conn -> {

            String sql = "{ call K_USUARIO.p_resetear_password(?, ?, ?, ?) }";

            try (CallableStatement cs = conn.prepareCall(sql)) {

                cs.setLong(1, idUsuario);
                cs.registerOutParameter(2, Types.VARCHAR);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                return ResetPasswordResponseDTO.builder()
                        .passwordTemporal(cs.getString(2))
                        .build();

            } catch (SQLException e) {
                throw new RuntimeException("Error al resetear password", e);
            }
        });
    }

    @Override
    @Transactional
    public void cambiarEstado(Long idUsuario) {

        StoredProcedureQuery sp = entityManager
                .createStoredProcedureQuery("K_USUARIO.p_modificar_estado");

        sp.registerStoredProcedureParameter("p_id_usuario", Long.class, ParameterMode.IN);
        sp.registerStoredProcedureParameter("p_cod_result", Integer.class, ParameterMode.OUT);
        sp.registerStoredProcedureParameter("p_msg_result", String.class, ParameterMode.OUT);

        sp.setParameter("p_id_usuario", idUsuario);

        sp.execute();

        Integer cod = (Integer) sp.getOutputParameterValue("p_cod_result");
        String msg = (String) sp.getOutputParameterValue("p_msg_result");

        if (cod == null || cod != 1) {
            throw new RuntimeException(msg != null ? msg : "Error al cambiar estado del usuario");
        }
    }

    @Override
    @Transactional(readOnly = true)
    public List<UsuarioResponseDTO> listarUsuarios() {

        return entityManager.unwrap(Session.class).doReturningWork(connection -> {

            String sql = "{ ? = call K_USUARIO.f_listar_usuarios(?, ?) }";

            try (CallableStatement cs = connection.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.registerOutParameter(2, Types.INTEGER);
                cs.registerOutParameter(3, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(2);
                String msg = cs.getString(3);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);

                List<UsuarioResponseDTO> usuarios = new ArrayList<>();

                while (rs.next()) {
                    usuarios.add(UsuarioResponseDTO.builder()
                            .idUsuario(rs.getLong("id_usuario"))
                            .usuario(rs.getString("usuario"))
                            .dni(rs.getString("dni"))
                            .nombres(rs.getString(4))
                            .area(rs.getString("area"))
                            .modalidad(rs.getString("modalidad"))
                            .horaIni(rs.getString("hora_ini"))
                            .horaFin(rs.getString("hora_fin"))
                            .estado(rs.getString("mca_estado"))
                            .telefono(rs.getString("telefono"))
                            .direccion(rs.getString("direccion"))
                            .correoPer(rs.getString("correo_per"))
                            .correoCor(rs.getString("correo_cor"))
                            .build());
                }

                rs.close();
                return usuarios;

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener los usuarios", e);
            }
        });
    }

    @Override
    @Transactional(readOnly = true)
    public List<UsuarioResponseDTO> buscarUsuarios(String texto) {

        return entityManager.unwrap(Session.class).doReturningWork(connection -> {

            String sql = "{ ? = call K_USUARIO.f_listar_usuarios_t(?, ?, ?) }";

            try (CallableStatement cs = connection.prepareCall(sql)) {

                cs.registerOutParameter(1, OracleTypes.CURSOR);
                cs.setString(2, texto);
                cs.registerOutParameter(3, Types.INTEGER);
                cs.registerOutParameter(4, Types.VARCHAR);

                cs.execute();

                int cod = cs.getInt(3);
                String msg = cs.getString(4);

                if (cod != 1) {
                    throw new ValidatedRequestException(msg);
                }

                ResultSet rs = (ResultSet) cs.getObject(1);

                List<UsuarioResponseDTO> fil_usuarios = new ArrayList<>();

                while (rs.next()) {
                    fil_usuarios.add(UsuarioResponseDTO.builder()
                                .idUsuario(rs.getLong("id_usuario"))
                                .usuario(rs.getString("usuario"))
                                .dni(rs.getString("dni"))
                                .nombres(rs.getString("nombres"))
                                .area(rs.getString("area"))
                                .modalidad(rs.getString("modalidad"))
                                .horaIni(rs.getString("hora_ini"))
                                .horaFin(rs.getString("hora_fin"))
                                .estado(rs.getString("mca_estado"))
                                .telefono(rs.getString("telefono"))
                                .direccion(rs.getString("direccion"))
                                .correoPer(rs.getString("correo_per"))
                                .correoCor(rs.getString("correo_cor"))
                                .build());
                }

                rs.close();
                return fil_usuarios;

            } catch (SQLException e) {
                throw new RuntimeException("Error al obtener los usuarios filtrados", e);
            }
        });
    }

}
