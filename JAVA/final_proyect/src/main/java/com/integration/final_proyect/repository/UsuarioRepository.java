package com.integration.final_proyect.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.integration.final_proyect.models.Usuario;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long>{

    Optional<Usuario> findByUsuario(String usuario);

    Optional<Usuario> findByCorreoCor(String correoCor);

}
