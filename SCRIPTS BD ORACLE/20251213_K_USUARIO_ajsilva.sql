create or replace PACKAGE k_usuario
AS 
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de usuarios y roles del
   || módulo de usuarios.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 07/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE USUARIO
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_generar_usuario: Genera el usuario unico
   ----------------------------------------------------------------*/
   --
   FUNCTION f_generar_usuario ( p_apel_pat      IN    usuario.apel_pat     %TYPE    ,
                                p_apel_mat      IN    usuario.apel_mat     %TYPE    ,
                                p_pri_nombre    IN    usuario.pri_nombre   %TYPE    ,
                                p_seg_nombre    IN    usuario.seg_nombre   %TYPE    ,
                                p_cod_result   OUT    NUMBER                        ,
                                p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN VARCHAR2;
   --
   /* -------------------------------------------------------------
   || f_obtener_dni_por_usuario: Obtener dni por usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_dni_por_usuario ( p_usuario      IN   usuario.usuario   %TYPE ,
                                        p_cod_result  OUT   NUMBER                  ,
                                        p_msg_result  OUT   VARCHAR2                )
   --
   RETURN usuario.dni%TYPE;
   --
   /* -------------------------------------------------------------
   || f_obtener_dni_por_id: Obtener dni por id de usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_dni_por_id ( p_id_usuario     IN   usuario.id_usuario   %TYPE ,
                                   p_cod_result    OUT   NUMBER                     ,
                                   p_msg_result    OUT   VARCHAR2                   )
   --
   RETURN usuario.dni%TYPE;
   --
   /* -------------------------------------------------------------
   || f_existe_usuario: Verifica si el usuario existe
   || (Retorna 1 = Si existe, 0 = no existe)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_existe_usuario ( p_dni           IN    usuario.dni    %TYPE  ,
                               p_cod_result   OUT    NUMBER                ,
                               p_msg_result   OUT    VARCHAR2              )
   --
   RETURN NUMBER;
   --
   /* -------------------------------------------------------------
   || f_obtener_usuario: Obtener al usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_usuario ( p_dni           IN    usuario.dni     %TYPE    ,
                                p_cod_result   OUT    NUMBER                   ,
                                p_msg_result   OUT    VARCHAR2                 )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || f_generar_hash: Realizar el Hashing al password plano
   ----------------------------------------------------------------*/
   --
   FUNCTION f_generar_hash ( p_password      IN    usuario.pass_usu     %TYPE    ,   
                             p_cod_result   OUT    NUMBER                        ,
                             p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN VARCHAR2;
   --
   /* -------------------------------------------------------------
   || p_actualizar_usuario: Actualiza el usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_usuario ( p_id_usuario          IN    usuario.id_usuario   %TYPE    ,
                                    p_area                IN    usuario.area         %TYPE    ,
                                    p_hora_ini            IN    usuario.hora_ini     %TYPE    ,
                                    p_hora_fin            IN    usuario.hora_fin     %TYPE    ,
                                    p_modalidad           IN    usuario.modalidad    %TYPE    ,
                                    p_apel_pat            IN    usuario.apel_pat     %TYPE    ,
                                    p_apel_mat            IN    usuario.apel_mat     %TYPE    ,
                                    p_pri_nombre          IN    usuario.pri_nombre   %TYPE    ,
                                    p_seg_nombre          IN    usuario.seg_nombre   %TYPE    ,
                                    p_dni 			       IN    usuario.dni          %TYPE    ,
                                    p_telefono		       IN    usuario.telefono     %TYPE    ,
                                    p_direccion	          IN    usuario.direccion    %TYPE    ,
                                    p_correo_per          IN    usuario.correo_per   %TYPE    ,
                                    p_regenerar_usuario   IN    VARCHAR2                      ,
                                    p_usuario            OUT    usuario.usuario      %TYPE    ,
                                    p_correo_cor         OUT    usuario.correo_cor   %TYPE    ,
                                    p_cod_result         OUT    NUMBER                        ,
                                    p_msg_result         OUT    VARCHAR2                      );
   --
   /* -------------------------------------------------------------
   || p_crear_usuario: Crea el usuario completo
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_usuario ( p_mca_estado   IN    usuario.mca_estado   %TYPE    ,
                               p_area         IN    usuario.area         %TYPE    ,
                               p_hora_ini     IN    usuario.hora_ini     %TYPE    ,
                               p_hora_fin     IN    usuario.hora_fin     %TYPE    ,
                               p_modalidad    IN    usuario.modalidad    %TYPE    ,
                               p_apel_pat     IN    usuario.apel_pat     %TYPE    ,
                               p_apel_mat     IN    usuario.apel_mat     %TYPE    ,
                               p_pri_nombre   IN    usuario.pri_nombre   %TYPE    ,
                               p_seg_nombre   IN    usuario.seg_nombre   %TYPE    ,
                               p_dni 			 IN    usuario.dni          %TYPE    ,
                               p_telefono		 IN    usuario.telefono     %TYPE    ,
                               p_direccion	 IN    usuario.direccion    %TYPE    ,
                               p_correo_per   IN    usuario.correo_per   %TYPE    ,
                               p_id_usuario  OUT    usuario.id_usuario   %TYPE    ,
                               p_usuario     OUT    usuario.usuario      %TYPE    ,
                               p_pass_usu    OUT    usuario.pass_usu     %TYPE    ,
                               p_correo_cor  OUT    usuario.correo_cor   %TYPE    ,
                               p_cod_result  OUT    NUMBER                        ,
                               p_msg_result  OUT    VARCHAR2                      );
   --
   /* -------------------------------------------------------------
   || p_actualizar_password: El usuairo cambia su contraseña
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_password ( p_id_usuario     IN    usuario.id_usuario      %TYPE    ,
                                     p_usuario        IN    usuario.usuario         %TYPE    ,
                                     p_old_password   IN    VARCHAR2                         ,
                                     p_new_password   IN    VARCHAR2                         ,
                                     p_cod_result    OUT    NUMBER                           ,
                                     p_msg_result    OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_resetear_password: Resetea la contraseña (ADMINS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_resetear_password ( p_id_usuario        IN      usuario.id_usuario   %TYPE    ,
                                   p_new_password     OUT      VARCHAR2                      ,
                                   p_cod_result       OUT      NUMBER                        ,
                                   p_msg_result       OUT      VARCHAR2                      );
   --
   /* -------------------------------------------------------------
   || p_modificar_estado: Cambia el estado del usuario 
   || ('S' Activo, 'N' Inactivo)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_modificar_estado ( p_id_usuario   IN    usuario.id_usuario  %TYPE    ,
                                  p_cod_result  OUT    NUMBER                       ,
                                  p_msg_result  OUT    VARCHAR2                     );
   --
   /* -------------------------------------------------------------
   || f_listar_usuarios: Obtener lista de usuarios
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_usuarios ( p_cod_result  OUT    NUMBER      ,
                                p_msg_result  OUT    VARCHAR2    )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || f_listar_usuarios_t: Buscar usuario por texto (Filtro en Front)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_usuarios_t ( p_texto        IN    VARCHAR2    ,
                                  p_cod_result  OUT    NUMBER      ,
                                  p_msg_result  OUT    VARCHAR2    )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   ||                      SECCION DE ROL
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || p_actualizar_rol: Editar un rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_rol ( p_id_rol        IN    rol.id_rol              %TYPE    ,
                                p_nombre        IN    rol.nombre              %TYPE    ,
                                p_cod_result   OUT    NUMBER                           ,
                                p_msg_result   OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_crear_rol: Crear un nuevo rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_rol ( p_nombre        IN    rol.nombre              %TYPE    ,
                           p_cod_result   OUT    NUMBER                           ,
                           p_msg_result   OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_eliminar_rol: Eliminar un rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_modificar_estado_rol ( p_id_rol        IN    rol.id_rol              %TYPE    ,
                                      p_cod_result   OUT    NUMBER                           ,
                                      p_msg_result   OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_asignar_rol: Asigna un rol al usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_asignar_rol ( p_id_usuario    IN    usuario.id_usuario      %TYPE    ,
                             p_id_rol        IN    rol.id_rol              %TYPE    ,
                             p_cod_result   OUT    NUMBER                           ,
                             p_msg_result   OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_quitar_rol: Quitar un rol al usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_quitar_rol ( p_id_usuario    IN    usuario.id_usuario      %TYPE    ,
                            p_id_rol        IN    rol.id_rol              %TYPE    ,
                            p_cod_result   OUT    NUMBER                           ,
                            p_msg_result   OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || f_roles_usuario: Muestra los roles del usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_roles_usuario ( p_id_usuario    IN    usuario.id_usuario     %TYPE   ,
                              p_cod_result   OUT    NUMBER                         ,
                              p_msg_result   OUT    VARCHAR2                       )
   --
   RETURN SYS_REFCURSOR;
   --
   /* -------------------------------------------------------------
   || p_listar_roles: Muestra los roles existentes
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_listar_roles ( p_cursor  OUT   SYS_REFCURSOR );
   --
   /* -------------------------------------------------------------
   ||                 SECCIÓN DE AUTENTICACIÓN
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_validar_login: Valida el login
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_login ( p_usuario       IN    usuario.usuario      %TYPE    ,
                              p_pass_usu      IN    usuario.pass_usu     %TYPE    ,
                              p_cod_result   OUT    NUMBER                        ,
                              p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN NUMBER;
   --
END k_usuario;

create or replace PACKAGE BODY k_usuario
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de usuarios y roles del
   || módulo de usuarios.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 07/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE USUARIO
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_generar_usuario: Genera el usuario unico
   ----------------------------------------------------------------*/
   --
   FUNCTION f_generar_usuario ( p_apel_pat      IN    usuario.apel_pat     %TYPE    ,
                                p_apel_mat      IN    usuario.apel_mat     %TYPE    ,
                                p_pri_nombre    IN    usuario.pri_nombre   %TYPE    ,
                                p_seg_nombre    IN    usuario.seg_nombre   %TYPE    ,
                                p_cod_result   OUT    NUMBER                        ,
                                p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN VARCHAR2
   --
   IS
      --
      l_candidato          VARCHAR2(50)   ;
      l_existe             NUMBER         ; 
      l_intento            NUMBER         ;
      l_len_nombre_pri     NUMBER         ;
      l_fallo_total        BOOLEAN        ;
      --
      l_pat                VARCHAR2(50);
      l_mat                VARCHAR2(50);
      l_nom1               VARCHAR2(50);
      l_nom2               VARCHAR2(50);
      --
   BEGIN
      --
      p_cod_result      := 0     ;
      p_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      l_intento         := 1     ;
      l_len_nombre_pri  := 1     ;
      l_fallo_total     := FALSE ;
      --
      l_pat  := LOWER(TRIM(p_apel_pat));
      l_mat  := LOWER(TRIM(p_apel_mat));
      l_nom1 := LOWER(TRIM(p_pri_nombre));
      l_nom2 := LOWER(TRIM(NVL(p_seg_nombre, '')));
      --
      LOOP
         --
         IF l_intento = 1 THEN
            -- Intento 1: Inicial Nombre + Apellido Paterno + Inicial Apellido Materno
            --
            l_candidato := SUBSTR( l_nom1, 1, 1)  ||
                                   l_pat          ||
                           SUBSTR( l_mat, 1, 1)    ;
         ELSIF l_intento = 2 THEN
            --
            IF l_nom2 IS NULL OR l_nom2 = '' THEN
            l_intento := 3;
            CONTINUE;
            END IF;
            -- 
            -- Intento 2: Inicial Nombre + Inicial Segundo Nombre + Apellido Paterno + Inicial Apellido Materno
            --
            l_candidato := SUBSTR( l_nom1, 1, 1)  ||
                           SUBSTR( l_nom2, 1, 1)  ||
                                   l_pat          ||
                           SUBSTR( l_mat, 1, 1)    ;
            -- 
         ELSIF l_intento = 3 AND l_len_nombre_pri <= 5 THEN
            -- Intento 3: Expandir el Primer Nombre (hasta 5 letras) + Apellido Paterno + Inicial Apellido Materno
            --
            l_candidato := SUBSTR( l_nom1, 1, l_len_nombre_pri)  ||
                                   l_pat                         ||
                           SUBSTR( l_mat, 1, 1)                   ;
            l_len_nombre_pri := l_len_nombre_pri + 1;
            --
         ELSIF l_intento = 4 AND l_len_nombre_pri <= 5 THEN
            --
            IF l_nom2 IS NULL OR l_nom2 = '' THEN
            l_intento := 5;
            CONTINUE;
            END IF;
            -- 
            -- Intento 4: Expandir el Primer Nombre (hasta 5 letras) + Inicial Segundo Nombre + Apellido Paterno + Inicial Apellido Materno
            --
            l_candidato := SUBSTR( l_nom1, 1, l_len_nombre_pri)  ||
                           SUBSTR( l_nom2, 1, 1)                 ||
                                   l_pat                         ||
                           SUBSTR( l_mat, 1, 1)                   ;
            l_len_nombre_pri := l_len_nombre_pri + 1;
            -- 
         ELSE
            -- EN CASO EXTREMO DE FALLO DE INTENTOS - AÑADIMOS NUMEROS
            FOR i IN 1..999 LOOP
               l_candidato := SUBSTR( l_nom1, 1, 1)  || 
                                      l_pat          || 
                              SUBSTR( l_mat,1,1)     || 
                                      i               ;

               SELECT COUNT(*)
               INTO l_existe
               FROM usuario
               WHERE usuario = l_candidato;

               IF l_existe = 0 THEN
                  p_cod_result := 1;
                  p_msg_result := 'USUARIO CREADO CORRECTAMENTE (SUFIJO): ' || l_candidato;
                  RETURN l_candidato;
               END IF;
            END LOOP;

            -- si llegamos hasta aquí, ya es demasiado raro
            l_fallo_total := TRUE;
            EXIT;
            --
         END IF;

         -- VERIFICAR USUARIO UNICO
         SELECT COUNT(*)
         INTO l_existe
         FROM usuario
         WHERE usuario = l_candidato;
         --
         EXIT WHEN l_existe = 0;

         IF l_intento = 1 THEN
            --
            l_intento := 2;
            --
         ELSIF l_intento = 2 THEN
            --
            l_intento := 3;
            l_len_nombre_pri := 1;
            --
         ELSIF l_intento = 3 AND l_len_nombre_pri > 5 THEN
            --
            l_intento := 4;
            l_len_nombre_pri := 1;
            --
         ELSIF l_intento = 4 AND l_len_nombre_pri > 5 THEN
            --
            l_intento := 5;
            --
         END IF;
         --
      END LOOP;
      --
      IF l_fallo_total THEN
         --
         p_cod_result := 1;
         p_msg_result := 'USUARIO NO CREADO - INTENTOS AGOTADOS (' || (l_intento - 1) || ')';
         RETURN NULL;
         --
      ELSE
         --
         p_cod_result := 1;
         p_msg_result := 'USUARIO CREADO CORRECTAMENTE: ' || l_candidato;
         RETURN l_candidato;
         --
      END IF;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_generar_usuario;
   --
   /* -------------------------------------------------------------
   || f_obtener_dni_por_usuario: Obtener dni por usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_dni_por_usuario ( p_usuario      IN   usuario.usuario   %TYPE ,
                                        p_cod_result  OUT   NUMBER                  ,
                                        p_msg_result  OUT   VARCHAR2                )
   --
   RETURN usuario.dni%TYPE
   --
   IS
      --
      l_dni usuario.dni%TYPE;
      --
   BEGIN
      --
      p_cod_result := 0;
      p_msg_result := 'PROCESO EJECUTADO';
      --
      BEGIN
         SELECT dni
         INTO l_dni
         FROM usuario
         WHERE usuario = p_usuario
           AND mca_estado = 'A';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            --
            p_cod_result := 1;
            p_msg_result := 'USUARIO NO ENCONTRADO';
            RETURN NULL;
            --
      END;
      --
      p_cod_result := 1;
      p_msg_result := 'DNI OBTENIDO';
      --
      RETURN l_dni;
      --
   EXCEPTION
      WHEN OTHERS THEN
         -- 
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985);
         RETURN NULL;
         --
   END f_obtener_dni_por_usuario;
   --
   /* -------------------------------------------------------------
   || f_obtener_dni_por_id: Obtener dni por id de usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_dni_por_id ( p_id_usuario     IN   usuario.id_usuario   %TYPE ,
                                   p_cod_result    OUT   NUMBER                     ,
                                   p_msg_result    OUT   VARCHAR2                   )
   --
   RETURN usuario.dni%TYPE
   --
   IS
      --
      l_dni usuario.dni%TYPE;
      --
   BEGIN
      --
      p_cod_result := 0;
      p_msg_result := 'PROCESO EJECUTADO';
      --
      BEGIN
         --
         SELECT dni
         INTO l_dni
         FROM usuario
         WHERE id_usuario = p_id_usuario;
         --
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            --
            p_cod_result := 1;
            p_msg_result := 'USUARIO NO ENCONTRADO';
            RETURN NULL;
            --
      END;
      --
      p_cod_result := 1;
      p_msg_result := 'DNI OBTENIDO';
      --
      RETURN l_dni;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985);
         RETURN NULL;
         --
   END f_obtener_dni_por_id;
   --
   /* -------------------------------------------------------------
   || f_existe_usuario: Verifica si el usuario existe
   || (Retorna 1 = Si existe, 0 = no existe)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_existe_usuario ( p_dni           IN    usuario.dni    %TYPE  ,
                               p_cod_result   OUT    NUMBER                ,
                               p_msg_result   OUT    VARCHAR2              )
   --
   RETURN NUMBER
   --
   IS
      --
      l_cantidad     NUMBER;
      --
   BEGIN
      --
      p_cod_result   := 0  ;
      p_msg_result   := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      SELECT COUNT(*)
      INTO l_cantidad
      FROM usuario
      WHERE dni = p_dni;
      --
      IF l_cantidad = 1 THEN
         --
         p_cod_result   := 1  ;
         p_msg_result   := 'EL USUARIO SI EXISTE' ;
         RETURN l_cantidad;
         --
      ELSE
         --
         p_cod_result   := 1  ;
         p_msg_result   := 'EL USUARIO NO EXISTE' ;
         RETURN l_cantidad;
         --
      END IF;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985);
         RETURN NULL;
         --
   END f_existe_usuario;
   --
   /* -------------------------------------------------------------
   || f_obtener_usuario: Obtener al usuario con su información
   ----------------------------------------------------------------*/
   --
   FUNCTION f_obtener_usuario ( p_dni           IN    usuario.dni     %TYPE    ,
                                p_cod_result   OUT    NUMBER                   ,
                                p_msg_result   OUT    VARCHAR2                 )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_existe          NUMBER            ;
      l_rec_cursor      SYS_REFCURSOR     ;
      --
      l_p_cod_result    NUMBER            ;
      l_p_msg_result    VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_p_cod_result    := 0  ;
      l_p_msg_result    := 'FUNCION INTERNA EJECUTADA EXITOSAMENTE' ;
      --
      p_cod_result      := 0  ;
      p_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      l_existe          := 0;
      --
      l_existe          := f_existe_usuario ( p_dni          =>   p_dni        ,
                                              p_cod_result   =>   l_p_cod_result ,
                                              p_msg_result   =>   l_p_msg_result );
      IF l_p_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_p_msg_result;
         RETURN NULL;
         -- 
      END IF;
      IF l_existe = 1 THEN
         --
         OPEN l_rec_cursor FOR
            --
            SELECT 
               id_usuario  ,
               dni         ,
               usuario     ,
               apel_pat || ' ' || apel_mat || ' ' || pri_nombre || ' ' || seg_nombre AS nombres,
               area        ,
               modalidad   ,
               hora_ini    ,
               hora_fin    ,
               telefono    ,
               direccion   ,
               correo_per  ,
               correo_cor  ,
               mca_estado
            FROM usuario
            WHERE dni = p_dni;
         --
         p_cod_result   := 1  ;
         p_msg_result   := 'USUARIO ENCONTRADO' ;
         --
         RETURN l_rec_cursor;
         --
      ELSE
         --
         p_cod_result   := 1   ;
         p_msg_result   := 'USUARIO NO ENCONTRADO' ;
         --
         RETURN l_rec_cursor;
         --
      END IF;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_obtener_usuario;
   --
   /* -------------------------------------------------------------
   || f_generar_hash: Realizar el Hashing al password plano
   ----------------------------------------------------------------*/
   --
   FUNCTION f_generar_hash ( p_password      IN    usuario.pass_usu     %TYPE    ,   
                             p_cod_result   OUT    NUMBER                        ,
                             p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN VARCHAR2
   --
   IS
      --
      l_salt_raw           RAW(16)        ;
      l_hashed_pass_raw    RAW(2048)      ;
      l_password_salted    RAW(200)       ;
      l_final_hash_salt    VARCHAR2(200)  ;
      l_salt_hex           VARCHAR2(32)   ;
      --
      l_cod_result         NUMBER         ;
      l_msg_result         VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      l_salt_raw        := DBMS_CRYPTO.RANDOMBYTES(16);
      l_salt_hex        := RAWTOHEX(l_salt_raw);
      l_password_salted := UTL_I18N.STRING_TO_RAW(p_password || l_salt_hex, 'AL32UTF8');
      l_hashed_pass_raw := DBMS_CRYPTO.HASH(l_password_salted, DBMS_CRYPTO.HASH_SH512);
      l_final_hash_salt := RAWTOHEX(l_hashed_pass_raw) || '.' || l_salt_hex;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'HASH GENERADO CON EXITO' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
      RETURN l_final_hash_salt;
      --
   EXCEPTION
      WHEN OTHERS THEN
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985);
         RETURN NULL;
   END f_generar_hash;
   --
   /* -------------------------------------------------------------
   || p_actualizar_usuario: Actualiza el usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_usuario ( p_id_usuario          IN    usuario.id_usuario   %TYPE    ,
                                    p_area                IN    usuario.area         %TYPE    ,
                                    p_hora_ini            IN    usuario.hora_ini     %TYPE    ,
                                    p_hora_fin            IN    usuario.hora_fin     %TYPE    ,
                                    p_modalidad           IN    usuario.modalidad    %TYPE    ,
                                    p_apel_pat            IN    usuario.apel_pat     %TYPE    ,
                                    p_apel_mat            IN    usuario.apel_mat     %TYPE    ,
                                    p_pri_nombre          IN    usuario.pri_nombre   %TYPE    ,
                                    p_seg_nombre          IN    usuario.seg_nombre   %TYPE    ,
                                    p_dni                 IN    usuario.dni          %TYPE    ,
                                    p_telefono            IN    usuario.telefono     %TYPE    ,
                                    p_direccion           IN    usuario.direccion    %TYPE    ,
                                    p_correo_per          IN    usuario.correo_per   %TYPE    ,
                                    p_regenerar_usuario   IN    VARCHAR2                      ,
                                    p_usuario            OUT    usuario.usuario      %TYPE    ,
                                    p_correo_cor         OUT    usuario.correo_cor   %TYPE    ,
                                    p_cod_result         OUT    NUMBER                        ,
                                    p_msg_result         OUT    VARCHAR2                      )
   --
   IS
      --
      l_usuario_actual  usuario.usuario      %TYPE ;
      l_usuario_nuevo   usuario.usuario      %TYPE ;
      l_correo_nuevo    usuario.correo_cor   %TYPE ;
      --
      l_cod_result      NUMBER                     ;
      l_msg_result      VARCHAR2(2000)             ;
      --
   BEGIN
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      SELECT usuario
      INTO l_usuario_actual
      FROM usuario
      WHERE id_usuario = p_id_usuario;
      --
      IF p_regenerar_usuario = 'S' THEN
         --
         l_usuario_nuevo := f_generar_usuario( p_apel_pat     =>  p_apel_pat      ,
                                               p_apel_mat     =>  p_apel_mat      ,
                                               p_pri_nombre   =>  p_pri_nombre    ,
                                               p_seg_nombre   =>  p_seg_nombre    ,
                                               p_cod_result   =>  l_cod_result    ,
                                               p_msg_result   =>  l_msg_result    );   
         --
         IF l_cod_result = 2 OR l_usuario_nuevo IS NULL THEN
            --
            p_cod_result := l_cod_result  ;
            p_msg_result := l_msg_result  ;
            RETURN;
            --
         END IF;
         --
         l_correo_nuevo := l_usuario_nuevo || '@company.com';
         --
      ELSE
         --
         l_usuario_nuevo := l_usuario_actual;
         --
         SELECT correo_cor 
         INTO l_correo_nuevo
         FROM usuario 
         WHERE id_usuario = p_id_usuario;
         --
       END IF;
      --
      UPDATE usuario
      SET apel_pat   = p_apel_pat      ,
          apel_mat   = p_apel_mat      ,
          pri_nombre = p_pri_nombre    ,
          seg_nombre = p_seg_nombre    ,
          dni        = p_dni           ,
          area       = p_area          ,
          hora_ini   = p_hora_ini      ,
          hora_fin   = p_hora_fin      ,
          modalidad  = p_modalidad     ,
          telefono   = p_telefono      ,
          direccion  = p_direccion     ,
          correo_per = p_correo_per    ,
          usuario    = l_usuario_nuevo ,
          correo_cor = l_correo_nuevo
      WHERE id_usuario = p_id_usuario;
      --
      IF SQL%ROWCOUNT = 0 THEN
         --
         p_cod_result := 1;
         p_msg_result := 'USUARIO NO ACTUALIZADO';
         RETURN;
         --
      END IF;
      --
      p_usuario     := l_usuario_nuevo;
      p_correo_cor  := l_correo_nuevo;
      --
      p_cod_result  := 1;
      p_msg_result  := 'USUARIO ACTUALIZADO EXITOSAMENTE';
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_actualizar_usuario;
   --
   /* -------------------------------------------------------------
   || p_crear_usuario: Crea el usuario completo
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_usuario ( p_mca_estado   IN    usuario.mca_estado   %TYPE    ,
                               p_area         IN    usuario.area         %TYPE    ,
                               p_hora_ini     IN    usuario.hora_ini     %TYPE    ,
                               p_hora_fin     IN    usuario.hora_fin     %TYPE    ,
                               p_modalidad    IN    usuario.modalidad    %TYPE    ,
                               p_apel_pat     IN    usuario.apel_pat     %TYPE    ,
                               p_apel_mat     IN    usuario.apel_mat     %TYPE    ,
                               p_pri_nombre   IN    usuario.pri_nombre   %TYPE    ,
                               p_seg_nombre   IN    usuario.seg_nombre   %TYPE    ,
                               p_dni          IN    usuario.dni          %TYPE    ,
                               p_telefono     IN    usuario.telefono     %TYPE    ,
                               p_direccion    IN    usuario.direccion    %TYPE    ,
                               p_correo_per   IN    usuario.correo_per   %TYPE    ,
                               p_id_usuario  OUT    usuario.id_usuario   %TYPE    ,
                               p_usuario     OUT    usuario.usuario      %TYPE    ,
                               p_pass_usu    OUT    usuario.pass_usu     %TYPE    ,
                               p_correo_cor  OUT    usuario.correo_cor   %TYPE    ,
                               p_cod_result  OUT    NUMBER                        ,
                               p_msg_result  OUT    VARCHAR2                      )
   --
   IS
      --
      l_existe          NUMBER                     ;
      l_usuario         usuario.usuario      %TYPE ;
      l_pass_plana      VARCHAR2(10)               ;
      l_correo_cor      usuario.correo_cor   %TYPE ;
      l_salt            usuario.salt_usu     %TYPE ;
      l_hash_salt       VARCHAR2(200)              ;
      l_hashed_pass     usuario.pass_usu     %TYPE ;
      --
      l_cod_result    NUMBER            ;
      l_msg_result    VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_existe          := 0  ;
      l_usuario         := '' ;
      l_pass_plana      := '' ;
      l_correo_cor      := '' ;
      l_salt            := '' ;
      l_hash_salt       := '' ;
      l_hashed_pass     := '' ;
      --
      l_cod_result    := 0  ;
      l_msg_result    := '1RA FUNCION INTERNA EJECUTADA EXITOSAMENTE' ;
      --
      l_existe          := f_existe_usuario ( p_dni          =>   p_dni          ,
                                              p_cod_result   =>   l_cod_result   ,
                                              p_msg_result   =>   l_msg_result   );
      IF l_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_msg_result;
         RETURN;
         -- 
      END IF;
      IF l_existe > 0 THEN
         --
         p_cod_result   := 1  ;
         p_msg_result   := 'EL DNI ' || p_dni || ' YA ESTÁ REGISTRADO'   ;
         RETURN;
         --
      END IF;
      --
      l_cod_result    := 0  ;
      l_msg_result    := '2DA FUNCION INTERNA EJECUTADA EXITOSAMENTE' ;
      --
      l_usuario   := f_generar_usuario ( p_apel_pat     =>    p_apel_pat      ,
                                         p_apel_mat     =>    p_apel_mat      ,
                                         p_pri_nombre   =>    p_pri_nombre    ,
                                         p_seg_nombre   =>    p_seg_nombre    ,
                                         p_cod_result   =>    l_cod_result    ,
                                         p_msg_result   =>    l_msg_result    );
      IF l_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_msg_result;
         RETURN;
         --
      END IF;
      --
      l_correo_cor   := l_usuario || '@company.com';
      --
      l_pass_plana   := DBMS_RANDOM.STRING('X', 10);
      --
      l_cod_result := 0  ;
      l_msg_result := '3RA FUNCION INTERNA EJECUTADA EXITOSAMENTE' ;
      --
      l_hash_salt    := f_generar_hash( p_password     => l_pass_plana      ,
                                        p_cod_result   => l_cod_result      ,
                                        p_msg_result   => l_msg_result      );
      IF l_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_msg_result;
         RETURN;
         --
      END IF;
      l_hashed_pass  := SUBSTR(l_hash_salt, 1, INSTR(l_hash_salt, '.') - 1);
      l_salt         := SUBSTR(l_hash_salt, INSTR(l_hash_salt, '.') + 1);
      --
      p_id_usuario   := seq_usuario.NEXTVAL  ;
      p_usuario      := l_usuario            ;
      p_pass_usu     := l_pass_plana         ;
      p_correo_cor   := l_correo_cor         ;
      --
      INSERT INTO usuario 
         (
            id_usuario  ,
            usuario     ,
            pass_usu    ,
            salt_usu    ,
            mca_estado  ,
            area        ,
            hora_ini    ,
            hora_fin    ,
            modalidad   ,
            apel_pat    ,
            apel_mat    ,
            pri_nombre  ,
            seg_nombre  ,
            dni         ,
            telefono    ,
            direccion   ,
            correo_per  ,
            correo_cor
         )
      VALUES
         (
            p_id_usuario   ,
            l_usuario      ,
            l_hashed_pass  ,
            l_salt         ,
            p_mca_estado   ,
            p_area         ,
            p_hora_ini     ,
            p_hora_fin     ,
            p_modalidad    ,
            p_apel_pat     ,
            p_apel_mat     ,
            p_pri_nombre   ,
            p_seg_nombre   ,
            p_dni          ,
            p_telefono     ,
            p_direccion    ,
            p_correo_per   ,
            l_correo_cor   
         );
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'USUARIO REGISTRADO CORRECTAMENTE CON EL ID: ' || p_id_usuario;
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
         p_id_usuario := NULL;
         p_usuario    := NULL;
         p_pass_usu   := NULL;
         --
   END p_crear_usuario;
   --
   /* -------------------------------------------------------------
   || p_actualizar_password: El usuairo cambia su contraseña
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_password ( p_id_usuario     IN    usuario.id_usuario      %TYPE    ,
                                     p_usuario        IN    usuario.usuario         %TYPE    ,
                                     p_old_password   IN    VARCHAR2                         ,
                                     p_new_password   IN    VARCHAR2                         ,
                                     p_cod_result    OUT    NUMBER                           ,
                                     p_msg_result    OUT    VARCHAR2                         )
   IS
      --
      l_hash_salt     VARCHAR2(200)          ;
      l_hashed_pass   usuario.pass_usu%TYPE  ;
      l_salt          usuario.salt_usu%TYPE  ;
      --
      l_hash_bd       usuario.pass_usu%TYPE;
      l_salt_bd       usuario.salt_usu%TYPE;
      l_salted_input  RAW(200);
      l_hash_calc_raw RAW(2048);
      --
      l_cod_result    NUMBER               ;
      l_msg_result    VARCHAR2(2000)       ;
      --
   BEGIN
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      BEGIN
         SELECT pass_usu, salt_usu
         INTO l_hash_bd, l_salt_bd
         FROM usuario
         WHERE id_usuario = p_id_usuario
           AND usuario    = p_usuario
           AND mca_estado = 'A';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_cod_result := 1;
            p_msg_result := 'USUARIO NO ENCONTRADO O INACTIVO';
            RETURN;
      END;
      --
      l_salted_input  := UTL_I18N.STRING_TO_RAW(p_old_password || l_salt_bd, 'AL32UTF8');
      l_hash_calc_raw := DBMS_CRYPTO.HASH(l_salted_input, DBMS_CRYPTO.HASH_SH512);
   
      IF RAWTOHEX(l_hash_calc_raw) != l_hash_bd THEN
         p_cod_result := 1;
         p_msg_result := 'LA CONTRASEÑA ACTUAL ES INCORRECTA';
         RETURN;
      END IF;
      --
      l_hash_salt := f_generar_hash ( p_password   => p_new_password  , 
                                      p_cod_result => l_cod_result    , 
                                      p_msg_result => l_msg_result    );
      IF l_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := l_msg_result;
         --
      END IF;
      --
      l_hashed_pass := SUBSTR(l_hash_salt, 1, INSTR(l_hash_salt, '.') - 1);
      l_salt        := SUBSTR(l_hash_salt, INSTR(l_hash_salt, '.') + 1);
      --
      UPDATE usuario
      SET pass_usu = l_hashed_pass,
          salt_usu = l_salt
      WHERE id_usuario = p_id_usuario
        AND usuario = p_usuario;
      --
      IF SQL%ROWCOUNT = 1 THEN
         --
         l_cod_result   := 1  ;
         l_msg_result   := 'CONTRASEÑA ACTUALIZADA EXITOSAMENTE' ;
         --
      ELSE
         --
         l_cod_result   := 1  ;
         l_msg_result   := 'CONTRASEÑA NO ACTUALIZADA' ;
         --
      END IF;
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_actualizar_password;
   --
   /* -------------------------------------------------------------
   || p_resetear_password: Resetea la contraseña (ADMINS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_resetear_password ( p_id_usuario        IN      usuario.id_usuario   %TYPE    ,
                                   p_new_password     OUT      VARCHAR2                      ,
                                   p_cod_result       OUT      NUMBER                        ,
                                   p_msg_result       OUT      VARCHAR2                      )
   --
   IS
      --
      l_hash_salt     VARCHAR2(200);
      l_hashed_pass   usuario.pass_usu %TYPE;
      l_salt          usuario.salt_usu %TYPE;
      --
   BEGIN
      --
      p_cod_result := 0;
      p_msg_result := 'PROCESO EJECUTADO';
      --
      p_new_password := DBMS_RANDOM.STRING('X', 10);
      --
      l_hash_salt := f_generar_hash( p_password    =>    p_new_password    ,
                                     p_cod_result  =>    p_cod_result      ,
                                     p_msg_result  =>    p_msg_result      );
      --
      IF p_cod_result = 2 THEN
         --
         RETURN;
         --
      END IF;
      --
      l_hashed_pass := SUBSTR(l_hash_salt, 1, INSTR(l_hash_salt, '.') - 1);
      l_salt        := SUBSTR(l_hash_salt, INSTR(l_hash_salt, '.') + 1);
      --
      UPDATE usuario
      SET pass_usu = l_hashed_pass,
          salt_usu = l_salt
      WHERE id_usuario = p_id_usuario;
      --
      IF SQL%ROWCOUNT = 0 THEN
         --
         p_cod_result := 1;
         p_msg_result := 'USUARIO NO ENCONTRADO';
         RETURN;
         --
      END IF;
      --
      p_cod_result := 1;
      p_msg_result := 'PASSWORD RESETEADO EXITOSAMENTE';
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_resetear_password;
   --
   /* -------------------------------------------------------------
   || p_modificar_estado: Cambia el estado del usuario 
   || ('A' Activo, 'I' Inactivo)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_modificar_estado ( p_id_usuario   IN    usuario.id_usuario  %TYPE    ,
                                  p_cod_result  OUT    NUMBER                       ,
                                  p_msg_result  OUT    VARCHAR2                     )
   IS
      --
      l_estado_actual   VARCHAR2(1)    ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_estado_actual   := '' ;
      --
      l_cod_result      := 0         ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      SELECT mca_estado
      INTO l_estado_actual
      FROM usuario
      WHERE id_usuario = p_id_usuario;
      --
      IF l_estado_actual = 'A' THEN
         --
         UPDATE usuario 
         SET mca_estado = 'I'
         WHERE id_usuario = p_id_usuario;
         --
         p_cod_result := 0;
         p_msg_result := 'ROL DESACTIVADO';
         --
      ELSE
         --
         UPDATE usuario 
         SET mca_estado = 'A'
         WHERE id_usuario = p_id_usuario;
         --
         p_cod_result := 0;
         p_msg_result := 'ROL ACTIVADO';
         --
      END IF;
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'ESTADO MODIFICADO EXITOSAMENTE';
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_modificar_estado;
   --
   /* -------------------------------------------------------------
   || f_listar_usuarios: Obtener lista de usuarios
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_usuarios ( p_cod_result  OUT    NUMBER      ,
                                p_msg_result  OUT    VARCHAR2    )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_rec_cursor   SYS_REFCURSOR     ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE';
      --
      OPEN l_rec_cursor FOR
         --
         SELECT id_usuario          ,
                usuario             ,
                dni                 ,
                apel_pat   || ' ' || apel_mat   || ' ' || 
                pri_nombre || ' ' || seg_nombre AS nombres,
                area                ,
                modalidad           ,
                hora_ini            ,
                hora_fin            ,
                mca_estado          ,
                telefono            ,
                direccion           ,
                correo_per          ,
                correo_cor          
         FROM usuario
         ORDER BY apel_pat;
      --
      l_cod_result      := 1                 ;
      l_msg_result      := 'RETORNO EXITOSO' ;
      --
      p_cod_result      := l_cod_result      ;
      p_msg_result      := l_msg_result      ;
      --
      RETURN l_rec_cursor;
      --
   END f_listar_usuarios;
   --
   /* -------------------------------------------------------------
   || f_listar_usuarios_t: Buscar usuario por texto (Filtro en Front)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_listar_usuarios_t ( p_texto        IN    VARCHAR2    ,
                                  p_cod_result  OUT    NUMBER      ,
                                  p_msg_result  OUT    VARCHAR2    )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_rec_cursor   SYS_REFCURSOR     ;
      l_filtro       VARCHAR2(255)     ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADa EXITOSAMENTE';
      --
      l_filtro          := UPPER('%' || p_texto || '%');
      --
      OPEN l_rec_cursor FOR
         --
         SELECT id_usuario          ,
                usuario             ,
                dni                 ,
                apel_pat || ' ' || apel_mat || ' ' ||
                pri_nombre || ' ' || seg_nombre AS nombres,
                area                ,
                modalidad           ,
                hora_ini            ,
                hora_fin            ,
                mca_estado          ,
                telefono            ,
                direccion           ,
                correo_per          ,
                correo_cor
         FROM usuario
         WHERE UPPER(usuario)    LIKE l_filtro
            OR UPPER(apel_pat)   LIKE l_filtro
            OR UPPER(apel_mat)   LIKE l_filtro
            OR UPPER(pri_nombre) LIKE l_filtro
            OR UPPER(seg_nombre) LIKE l_filtro
            OR UPPER(correo_cor) LIKE l_filtro
            OR       dni         LIKE l_filtro;
         --
      --
      l_cod_result      := 1                 ;
      l_msg_result      := 'RETORNO EXITOSO' ;
      --
      p_cod_result      := l_cod_result      ;
      p_msg_result      := l_msg_result      ;
      --
      RETURN l_rec_cursor;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END f_listar_usuarios_t;
   --
   /* -------------------------------------------------------------
   ||                      SECCION DE ROL
   ----------------------------------------------------------------*/
   --
   --
   /* -------------------------------------------------------------
   || p_actualizar_rol: Editar un rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_actualizar_rol ( p_id_rol        IN    rol.id_rol              %TYPE    ,
                                p_nombre        IN    rol.nombre              %TYPE    ,
                                p_cod_result   OUT    NUMBER                           ,
                                p_msg_result   OUT    VARCHAR2                         )
   IS
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      UPDATE rol
      SET nombre = p_nombre
      WHERE id_rol = p_id_rol;
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'ROL ACTUALIZADO EXITOSAMENTE';
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_actualizar_rol;
   --
   /* -------------------------------------------------------------
   || p_crear_rol: Crear un nuevo rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_rol ( p_nombre        IN    rol.nombre              %TYPE    ,
                           p_cod_result   OUT    NUMBER                           ,
                           p_msg_result   OUT    VARCHAR2                         )
   IS
      --
      l_id_rol          rol.id_rol  %TYPE ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      l_id_rol          := seq_rol.NEXTVAL;
      --
      INSERT INTO rol
         (
            id_rol,
            nombre,
            mca_estado
         )
      VALUES
         (
            l_id_rol,
            p_nombre,
            'A'
         );
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'ROL CREADO EXITOSAMENTE';
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_crear_rol;
   --
   /* -------------------------------------------------------------
   || p_modificar_estado_rol: Modifica el estado del rol
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_modificar_estado_rol ( p_id_rol        IN    rol.id_rol     %TYPE    ,
                                      p_cod_result   OUT    NUMBER                  ,
                                      p_msg_result   OUT    VARCHAR2                )
   IS
      --
      l_estado_actual   VARCHAR2(1)       ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_estado_actual   := '' ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      SELECT mca_estado
      INTO l_estado_actual
      FROM rol
      WHERE id_rol = p_id_rol;
      --
      IF l_estado_actual = 'A' THEN
         --
         UPDATE rol 
         SET mca_estado = 'I'
         WHERE id_rol = p_id_rol;
         --
         p_cod_result := 0;
         p_msg_result := 'ROL DESACTIVADO';
         --
      ELSE
         --
         UPDATE rol 
         SET mca_estado = 'A'
         WHERE id_rol = p_id_rol;
         --
         p_cod_result := 0;
         p_msg_result := 'ROL ACTIVADO';
         --
      END IF;
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'ESTADO MODIFICADO EXITOSAMENTE';
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_modificar_estado_rol;
   --
   /* -------------------------------------------------------------
   || p_asignar_rol: Asigna un rol al usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_asignar_rol ( p_id_usuario    IN    usuario.id_usuario      %TYPE    ,
                             p_id_rol        IN    rol.id_rol              %TYPE    ,
                             p_cod_result   OUT    NUMBER                           ,
                             p_msg_result   OUT    VARCHAR2                         )
   IS
      --
      l_existe          NUMBER         ;
      l_id_usuario_rol  usuario_rol.id_usuario_rol    %TYPE ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_existe          := 0  ;
      l_id_usuario_rol  := 0  ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      SELECT COUNT(*)
      INTO l_existe
      FROM usuario_rol
      WHERE id_usuario = p_id_usuario
        AND id_rol     = p_id_rol;
      
      IF l_existe > 0 THEN
         p_cod_result := 1;
         p_msg_result := 'EL USUARIO YA TIENE ESTE ROL';
         RETURN;
      END IF;
      --
      l_id_usuario_rol  := seq_usuario_rol.NEXTVAL;
      --
      INSERT INTO usuario_rol
         (
            id_usuario_rol,
            id_usuario,
            id_rol
         )
      VALUES
         (
            l_id_usuario_rol,
            p_id_usuario,
            p_id_rol
         );
      --
      l_cod_result      := 1                 ;
      l_msg_result      := 'ROL ASIGNADO EXITOSAMENTE' ;
      --
      p_cod_result      := l_cod_result      ;
      p_msg_result      := l_msg_result      ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_asignar_rol;
   --
   /* -------------------------------------------------------------
   || p_quitar_rol: Quitar un rol al usuario
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_quitar_rol ( p_id_usuario    IN    usuario.id_usuario      %TYPE    ,
                            p_id_rol        IN    rol.id_rol              %TYPE    ,
                            p_cod_result   OUT    NUMBER                           ,
                            p_msg_result   OUT    VARCHAR2                         )
   IS
   --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      DELETE FROM usuario_rol
      WHERE id_usuario  = p_id_usuario
        AND id_rol      = p_id_rol;
      --
      l_cod_result      := 1                 ;
      l_msg_result      := 'ROL ELIMINADO EXITOSAMENTE' ;
      --
      p_cod_result      := l_cod_result      ;
      p_msg_result      := l_msg_result      ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_quitar_rol;
   --
   /* -------------------------------------------------------------
   || f_roles_usuario: Muestra los roles del usuario
   ----------------------------------------------------------------*/
   --
   FUNCTION f_roles_usuario ( p_id_usuario    IN    usuario.id_usuario     %TYPE   ,
                              p_cod_result   OUT    NUMBER                         ,
                              p_msg_result   OUT    VARCHAR2                       )
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_rec_cursor   SYS_REFCURSOR     ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE';
      --
      OPEN l_rec_cursor FOR
         --
         SELECT a.id_rol, a.nombre, a.mca_estado
         FROM rol a, usuario_rol b
         WHERE a.id_rol       = b.id_rol
           AND b.id_usuario   = p_id_usuario;
         --
      --
      l_cod_result      := 1                 ;
      l_msg_result      := 'ROLES RETORNADOS EXITOSAMENTE' ;
      --
      p_cod_result      := l_cod_result      ;
      p_msg_result      := l_msg_result      ;
      --
      RETURN l_rec_cursor;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END f_roles_usuario;
   --
   /* -------------------------------------------------------------
   || f_listar_roles: Muestra los roles existentes
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_listar_roles ( p_cursor  OUT   SYS_REFCURSOR )
   --
   IS
   --
   BEGIN
      --
      OPEN p_cursor FOR
         --
         SELECT id_rol     ,
                nombre     ,
                mca_estado         
         FROM rol
         ORDER BY mca_estado;
      --
   END p_listar_roles;
   --
   /* -------------------------------------------------------------
   ||                 SECCIÓN DE AUTENTICACIÓN
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_validar_login: Valida el login 
   || (ID = correcto - NUll = incorrecto)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_login ( p_usuario       IN    usuario.usuario      %TYPE    ,
                              p_pass_usu      IN    usuario.pass_usu     %TYPE    ,
                              p_cod_result   OUT    NUMBER                        ,
                              p_msg_result   OUT    VARCHAR2                      )
   --
   RETURN NUMBER
   --
   IS
      --
      l_hash_bd         usuario.pass_usu     %TYPE    ;
      l_salt_bd         usuario.salt_usu     %TYPE    ;
      l_id_usuario      usuario.id_usuario   %TYPE    ;
      l_hash_calc_raw   RAW(2048)                     ;
      l_salted_input    RAW(200)                      ;
      l_password_salt   VARCHAR2(200)                 ;
      --
      l_cod_result      NUMBER                        ;
      l_msg_result      VARCHAR2(2000)                ;
      --
   BEGIN
      --
      p_cod_result := 0;
      p_msg_result := 'FUNCION EJECUTADA EXITOSAMENTE';
      --
      BEGIN
         SELECT id_usuario, pass_usu, salt_usu
         INTO l_id_usuario, l_hash_bd, l_salt_bd
         FROM usuario
         WHERE usuario     = p_usuario
           AND mca_estado  = 'A';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_cod_result := 1;
            p_msg_result := 'USUARIO O CONTRASEÑA INCORRECTOS';
            RETURN NULL;
      END;
      --
      l_password_salt   := p_pass_usu || l_salt_bd;
      l_salted_input    := UTL_I18N.STRING_TO_RAW(l_password_salt, 'AL32UTF8');
      l_hash_calc_raw   := DBMS_CRYPTO.HASH(l_salted_input, DBMS_CRYPTO.HASH_SH512);
      --
      IF RAWTOHEX(l_hash_calc_raw) = l_hash_bd THEN
         p_cod_result := 1;
         p_msg_result := 'LOGIN EXITOSO';
         RETURN l_id_usuario;
      ELSE
         p_cod_result := 1;
         p_msg_result := 'USUARIO O CONTRASEÑA INCORRECTOS';
         RETURN NULL;
      END IF;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985);
         RETURN NULL;
         --
   END f_validar_login;
   --
END k_usuario;