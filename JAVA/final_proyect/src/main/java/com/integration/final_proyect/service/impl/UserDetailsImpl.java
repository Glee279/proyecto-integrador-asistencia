package com.integration.final_proyect.service.impl;

import java.util.Collection;
import java.util.List;

import org.springframework.lang.Nullable;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import com.integration.final_proyect.models.Usuario;
import com.integration.final_proyect.models.UsuarioRol;

public class UserDetailsImpl implements UserDetails {

    private final Usuario usuario;
    private final List<UsuarioRol> roles;

    public UserDetailsImpl(Usuario usuario, List<UsuarioRol> roles) {
        this.usuario = usuario;
        this.roles = roles;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles.stream()
                .map(r -> new SimpleGrantedAuthority("ROLE_" + r.getRol().getNombre()))
                .toList();
    }

    @Override
    public @Nullable String getPassword() {
        return usuario.getPassUsu();
    }

    @Override
    public String getUsername() {
        return usuario.getUsuario();
    }

    @Override
    public boolean isAccountNonExpired() { return true; }

    @Override
    public boolean isAccountNonLocked() { return true; }

    @Override
    public boolean isCredentialsNonExpired() { return true; }

    @Override
    public boolean isEnabled() {
        return usuario.getMcaEstado().equals("A");
    }

}
