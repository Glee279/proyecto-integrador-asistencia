create or replace PACKAGE k_asistencia 
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la asistencia del módulo
   || de asistencia.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 08/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE ASISTENCIA
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_asistencia_activa: Validar usuario activo
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_usuario ( p_id_usuario     IN   usuario.id_usuario  %TYPE ,
                                p_cod_result    OUT   NUMBER                    ,
                                p_msg_result    OUT   VARCHAR2                  )
   --
   RETURN VARCHAR2;
   --
   /* -------------------------------------------------------------
   || f_asistencia_activa: Obtener asistencia activa del día
   ----------------------------------------------------------------*/
   --
   FUNCTION f_asistencia_activa ( p_id_usuario     IN   usuario.id_usuario  %TYPE ,
                                  p_cod_result    OUT   NUMBER                    ,
                                  p_msg_result    OUT   VARCHAR2                  )
   --
   RETURN asistencia.id_asistencia  %TYPE ;
   --
   /* -------------------------------------------------------------
   || p_crear_entrada: Creación de la entrada
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_entrada ( p_id_usuario       IN  usuario.id_usuario         %TYPE    ,
                               p_id_sede          IN  asistencia.id_sede         %TYPE    ,
                               p_mca_estado       IN  asistencia.mca_estado      %TYPE    ,
                               p_tip_asistencia   IN  asistencia.tip_asistencia  %TYPE    ,
                               p_id_asistencia   OUT  asistencia.id_asistencia   %TYPE    ,
                               p_cod_result      OUT  NUMBER                              ,
                               p_msg_result      OUT  VARCHAR2                            );
   --
   /* -------------------------------------------------------------
   || p_registrar_manual: Registra la asistencia manualmente
   || (EMPLEADOS REMOTOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_entrada_manual ( p_id_usuario       IN   usuario.id_usuario         %TYPE    ,
                                          p_id_asistencia   OUT   asistencia.id_asistencia   %TYPE    ,
                                          p_cod_result      OUT   NUMBER                              ,
                                          p_msg_result      OUT   VARCHAR2                            );
   --
   /* -------------------------------------------------------------
   || p_registrar_qr: Registra la asistencia por QR
   || (EMPLEADOS PRESENCIALES - HIBRIDOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_entrada_qr ( p_id_usuario       IN   usuario.id_usuario         %TYPE  ,
                                      p_codigo_qr        IN   qr_token.codigo_qr         %TYPE  ,
                                      p_id_asistencia   OUT   asistencia.id_asistencia   %TYPE  ,
                                      p_cod_result      OUT   NUMBER                            ,
                                      p_msg_result      OUT   VARCHAR2                          );
   --
   /* -------------------------------------------------------------
   || p_registrar_salida: Registra la salida de forma manual
   || (EMPLEADOS REMOTOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_salida_manual ( p_id_usuario       IN    usuario.id_usuario       %TYPE   ,
                                         p_id_asistencia   OUT    asistencia.id_asistencia %TYPE   ,
                                         p_cod_result      OUT    NUMBER                           ,
                                         p_msg_result      OUT    VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_registrar_salida_qr: Registra la salida por QR
   || (EMPLEADOS PRESENCIALES - HIBRIDOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_salida_qr ( p_id_usuario       IN  usuario.id_usuario         %TYPE ,
                                     p_codigo_qr        IN  qr_token.codigo_qr         %TYPE ,
                                     p_id_asistencia   OUT  asistencia.id_asistencia   %TYPE ,
                                     p_cod_result      OUT  NUMBER                           ,
                                     p_msg_result      OUT  VARCHAR2                         );
   --
   /* -------------------------------------------------------------
   || p_cerrar_registros_antiguos: Cerrar asistencias abiertas 
   || de días anteriores
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_cerrar_registros_antiguos ( p_cod_result  OUT  NUMBER    ,
                                           p_msg_result  OUT  VARCHAR2  );
   --
END k_asistencia;

create or replace PACKAGE BODY k_asistencia 
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión de la asistencia del módulo
   || de asistencia.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 08/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE ASISTENCIA
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || f_asistencia_activa: Validar usuario activo
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_usuario ( p_id_usuario     IN   usuario.id_usuario  %TYPE ,
                                p_cod_result    OUT   NUMBER                    ,
                                p_msg_result    OUT   VARCHAR2                  )
   --
   RETURN VARCHAR2
   --
   IS
      --
      l_mca_estado      usuario.mca_estado   %TYPE ;
      --
      l_cod_result      NUMBER                     ;
      l_msg_result      VARCHAR2(2000)             ;
      --
   BEGIN
      --
      l_mca_estado   := NULL ;
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      BEGIN
         SELECT mca_estado
         INTO l_mca_estado
         FROM usuario
         WHERE id_usuario = p_id_usuario;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_cod_result := 0;
            p_msg_result := 'USUARIO NO ENCONTRADO';
            RETURN NULL;
      END;
      --
      IF l_mca_estado <> 'A' OR l_mca_estado IS NULL THEN
         --
         p_cod_result   := 0  ;
         p_msg_result   := 'USUARIO INACTIVO' ;
         RETURN p_msg_result;
         --
      END IF;
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'USUARIO ACTIVO'   ;
      --
      p_cod_result   := l_cod_result         ;
      p_msg_result   := l_msg_result         ;
      --
      RETURN p_msg_result;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_validar_usuario;
   --
   /* -------------------------------------------------------------
   || f_asistencia_activa: Obtener asistencia activa del día
   ----------------------------------------------------------------*/
   --
   FUNCTION f_asistencia_activa ( p_id_usuario     IN   usuario.id_usuario  %TYPE ,
                                  p_cod_result    OUT   NUMBER                    ,
                                  p_msg_result    OUT   VARCHAR2                  )
   --
   RETURN asistencia.id_asistencia  %TYPE 
   --
   IS
      --
      l_id_asistencia   asistencia.id_asistencia   %TYPE ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_id_asistencia   := 0 ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      BEGIN
         SELECT id_asistencia
         INTO l_id_asistencia
         FROM asistencia
         WHERE id_usuario = p_id_usuario
           AND TRUNC(fec_entrada) = TRUNC(SYSDATE)
           AND fec_salida IS NULL;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            p_cod_result := 0;
            p_msg_result := 'NO EXISTE ASISTENCIA ABIERTA';
            RETURN NULL;
      END;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'ASISTENCIA ACTIVA' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
      RETURN l_id_asistencia;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_asistencia_activa;
   --
   /* -------------------------------------------------------------
   || p_crear_entrada: Creación de la entrada
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_crear_entrada ( p_id_usuario       IN  usuario.id_usuario         %TYPE    ,
                               p_id_sede          IN  asistencia.id_sede         %TYPE    ,
                               p_mca_estado       IN  asistencia.mca_estado      %TYPE    ,
                               p_tip_asistencia   IN  asistencia.tip_asistencia  %TYPE    ,
                               p_id_asistencia   OUT  asistencia.id_asistencia   %TYPE    ,
                               p_cod_result      OUT  NUMBER                              ,
                               p_msg_result      OUT  VARCHAR2                            )
   IS
      --
      l_id_asistencia   asistencia.id_asistencia   %TYPE ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_id_asistencia   := 0  ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      l_id_asistencia   := seq_asistencia.NEXTVAL;
      --
      INSERT INTO asistencia
         (
            id_asistencia  ,
            id_usuario     ,
            id_sede        ,
            fec_entrada    ,
            mca_estado     ,
            tip_asistencia 
         )
      VALUES
         (
            l_id_asistencia   ,
            p_id_usuario      ,
            p_id_sede         ,
            SYSDATE           ,
            p_mca_estado      ,
            p_tip_asistencia  
         )
      RETURNING id_asistencia INTO p_id_asistencia;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'ENTRADA CREADA' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END p_crear_entrada;
   --
   /* -------------------------------------------------------------
   || p_registrar_manual: Registra la asistencia manualmente
   || (EMPLEADOS REMOTOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_entrada_manual ( p_id_usuario       IN   usuario.id_usuario         %TYPE    ,
                                          p_id_asistencia   OUT   asistencia.id_asistencia   %TYPE    ,
                                          p_cod_result      OUT   NUMBER                              ,
                                          p_msg_result      OUT   VARCHAR2                            )
   IS
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_msg_result      := f_validar_usuario ( p_id_usuario   =>    p_id_usuario   ,
                                               p_cod_result   =>    l_cod_result   ,
                                               p_msg_result   =>    l_msg_result   );
      --
      IF l_cod_result <> 0 THEN
         --
         p_cod_result   :=    l_cod_result   ;
         p_msg_result   :=    l_msg_result   ;
         RETURN;
         --
      END IF;
      --
      p_crear_entrada ( p_id_usuario     =>   p_id_usuario     ,
                        p_id_sede        =>   NULL             ,
                        p_mca_estado     =>   'RI'             ,  -- REGISTRO INCOMPLETO
                        p_tip_asistencia =>   'MANUAL'         ,
                        p_id_asistencia  =>   p_id_asistencia  ,
                        p_cod_result     =>   l_cod_result     ,
                        p_msg_result     =>   l_msg_result     );
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'ENTRADA MANUAL CREADA' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         p_id_asistencia   := NULL;
         --
   END p_registrar_entrada_manual;
   --
   /* -------------------------------------------------------------
   || p_registrar_qr: Registra la asistencia por QR
   || (EMPLEADOS PRESENCIALES - HIBRIDOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_entrada_qr ( p_id_usuario       IN   usuario.id_usuario         %TYPE  ,
                                      p_codigo_qr        IN   qr_token.codigo_qr         %TYPE  ,
                                      p_id_asistencia   OUT   asistencia.id_asistencia   %TYPE  ,
                                      p_cod_result      OUT   NUMBER                            ,
                                      p_msg_result      OUT   VARCHAR2                          )
   IS
      --
      l_id_sede         sede.id_sede         %TYPE ;
      l_ok              BOOLEAN                    ;
      l_cantidad        NUMBER                     ;
      l_qr_auto_id      qr_token.id_qr       %TYPE ;
      l_qr_auto_codigo  qr_token.codigo_qr   %TYPE ;
      --
      l_cod_result      NUMBER                     ;
      l_msg_result      VARCHAR2(2000)             ;
      --
   BEGIN
      --
      l_id_sede         := NULL  ;
      l_ok              := NULL  ;
      l_cantidad        := 0     ;
      l_qr_auto_id      := NULL  ;
      l_qr_auto_codigo  := NULL  ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_msg_result      := f_validar_usuario ( p_id_usuario   =>    p_id_usuario   ,
                                               p_cod_result   =>    l_cod_result   ,
                                               p_msg_result   =>    l_msg_result   );
      --
      IF l_cod_result <> 0 THEN
         --
         p_cod_result   :=    l_cod_result   ;
         p_msg_result   :=    l_msg_result   ;
         RETURN;
         --
      END IF;
      --
      l_ok := k_qr_token.f_validar_qr ( p_codigo_qr   => p_codigo_qr    ,
                                        p_id_sede     => l_id_sede      ,
                                        p_cod_result  => l_cod_result   , 
                                        p_msg_result  => l_msg_result   );
      --
      IF NOT l_ok THEN
         --
         p_cod_result   := 0              ;
         p_msg_result   := l_msg_result   ;
         RETURN;
         --
      END IF;
      --
      SELECT COUNT(*)
      INTO l_cantidad
      FROM asistencia
      WHERE id_usuario = p_id_usuario
        AND fec_salida IS NULL
        AND mca_baja = 'N';
      --
      IF l_cantidad > 0 THEN
         --
         p_cod_result := 1;
         p_msg_result := 'YA EXISTE UNA ENTRADA ABIERTA';
         RETURN;
         --
      END IF;
      --
      INSERT INTO asistencia 
         (
            id_asistencia,
            id_usuario,
            id_sede,
            fec_entrada,
            tip_asistencia,
            mca_estado,
            mca_baja
         ) 
      VALUES 
         (
            seq_asistencia.NEXTVAL  ,
            p_id_usuario            ,
            l_id_sede               ,
            SYSDATE                 ,
            'QR'                    ,
            'RI'                    ,
            'N'
         )
      RETURNING id_asistencia INTO p_id_asistencia;
      --
      UPDATE qr_token
      SET mca_estado = 'E'
      WHERE codigo_qr = p_codigo_qr;
      --
      k_qr_token.p_generar_qr ( p_id_sede       =>    l_id_sede         ,
                                p_minutos       =>    5                 ,
                                p_id_qr         =>    l_qr_auto_id      ,
                                p_codigo_qr     =>    l_qr_auto_codigo  ,
                                p_cod_result    =>    l_cod_result      ,
                                p_msg_result    =>    l_msg_result      );
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'ENTRADA QR CREADA' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --p_msg_result := 'ERROR: ' || SQLERRM || ' | ' || DBMS_UTILITY.format_error_backtrace;
         p_id_asistencia   := NULL;
         --
   END p_registrar_entrada_qr;
   --
   /* -------------------------------------------------------------
   || p_registrar_salida: Registra la salida de forma manual
   || (EMPLEADOS REMOTOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_salida_manual ( p_id_usuario       IN    usuario.id_usuario       %TYPE   ,
                                         p_id_asistencia   OUT    asistencia.id_asistencia %TYPE   ,
                                         p_cod_result      OUT    NUMBER                           ,
                                         p_msg_result      OUT    VARCHAR2                         )
   IS
      --
      l_id_asistencia   asistencia.id_asistencia %TYPE   ;
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_id_asistencia   := f_asistencia_activa ( p_id_usuario     => p_id_usuario   ,
                                                 p_cod_result     => l_cod_result   ,
                                                 p_msg_result     => l_msg_result   );
      --
      IF l_cod_result = 2 THEN
         --
         p_cod_result   := 2              ;
         p_msg_result   := l_msg_result   ;
         RETURN;
         --
      END IF;
      --
      IF l_id_asistencia IS NOT NULL THEN
         --
         UPDATE asistencia
         SET    fec_salida = SYSDATE,
                mca_estado = 'RC'      -- REGISTRO COMPLETO
         WHERE  id_asistencia = l_id_asistencia;
         --
         l_cod_result   := 1  ;
         l_msg_result   := 'SALIDA REGISTRADA' ;
         --
      ELSE
         --
         l_cod_result   := 1  ;
         l_msg_result   := 'SALIDA NO REGISTRADA' ;
         --
      END IF;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         p_id_asistencia   := NULL;
         --
   END p_registrar_salida_manual;
   --
   /* -------------------------------------------------------------
   || p_registrar_salida_qr: Registra la salida por QR
   || (EMPLEADOS PRESENCIALES - HIBRIDOS)
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_registrar_salida_qr ( p_id_usuario       IN  usuario.id_usuario         %TYPE ,
                                     p_codigo_qr        IN  qr_token.codigo_qr         %TYPE ,
                                     p_id_asistencia   OUT  asistencia.id_asistencia   %TYPE ,
                                     p_cod_result      OUT  NUMBER                           ,
                                     p_msg_result      OUT  VARCHAR2                         )
   IS
      --
      l_id_sede         sede.id_sede   %TYPE ;
      l_ok              BOOLEAN              ;
      --
      l_cod_result      NUMBER               ;
      l_msg_result      VARCHAR2(2000)       ;
      --
   BEGIN
      --
      l_id_sede         := 0     ;
      l_ok              := NULL  ;
      --
      l_cod_result      := 0     ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_ok := k_qr_token.f_validar_qr ( p_codigo_qr   => p_codigo_qr    ,
                                        p_id_sede     => l_id_sede      ,
                                        p_cod_result  => l_cod_result   , 
                                        p_msg_result  => l_msg_result   );
      --
      IF NOT l_ok THEN
         --
         p_cod_result   := 0              ;
         p_msg_result   := l_msg_result   ;
         RETURN;
         --
      END IF;
      --
      UPDATE asistencia
      SET fec_salida = SYSDATE,
          mca_estado = 'RC'
      WHERE id_usuario = p_id_usuario
        AND fec_salida IS NULL
        AND id_sede = l_id_sede
        AND mca_baja = 'N'
      RETURNING id_asistencia INTO p_id_asistencia;
      --
      IF SQL%ROWCOUNT = 0 THEN
         --
         p_cod_result := 1;
         p_msg_result := 'NO EXISTE ASISTENCIA ABIERTA EN LA SEDE';
         RETURN;
         --
      END IF;
      --
      UPDATE qr_token
      SET mca_estado = 'E'
      WHERE codigo_qr = p_codigo_qr;
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'SALIDA QR REGISTRADA' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result      := 2 ;
         p_msg_result      := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         p_id_asistencia   := NULL;
         --
   END p_registrar_salida_qr;
   --
   /* -------------------------------------------------------------
   || p_cerrar_registros_antiguos: Cerrar asistencias abiertas 
   || de días anteriores
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_cerrar_registros_antiguos ( p_cod_result  OUT  NUMBER    ,
                                           p_msg_result  OUT  VARCHAR2  )
   IS
      --
      l_cod_result      NUMBER            ;
      l_msg_result      VARCHAR2(2000)    ;
      --
   BEGIN
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      UPDATE asistencia
      SET fec_salida = TRUNC(fec_entrada) + 1 - (1/1440),
          mca_estado = 'RC'
      WHERE fec_salida IS NULL
        AND trunc(fec_entrada) < trunc(SYSDATE);
      --
      l_cod_result      := 1  ;
      l_msg_result      := 'REGISTROS ANTIGUOS CERRADOS' ;
      --
      p_cod_result      := l_cod_result   ;
      p_msg_result      := l_msg_result   ;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         --
   END;
   --
END k_asistencia;