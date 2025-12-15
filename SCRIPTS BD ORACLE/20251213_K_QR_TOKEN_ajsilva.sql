create or replace PACKAGE k_qr_token
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión del qr/token para el módulo
   || de asistencia.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 08/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE QR TOKEN
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || p_invalidar_qr_sede: Expira todos los qr activos de una sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_invalidar_qr_sede ( p_id_sede      IN     qr_token.id_sede   %TYPE     ,
                                   p_cod_result  OUT     NUMBER                       ,
                                   p_msg_result  OUT     VARCHAR2                     );
   --
   /* -------------------------------------------------------------
   || p_generar_qr: Genera el qr
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_generar_qr ( p_id_sede      IN   qr_token.id_sede    %TYPE     ,
                            p_minutos      IN   NUMBER                        ,
                            p_id_qr       OUT   qr_token.id_qr      %TYPE     ,
                            p_codigo_qr   OUT   qr_token.codigo_qr  %TYPE     ,
                            p_cod_result  OUT   NUMBER                        ,
                            p_msg_result  OUT   VARCHAR2                      );
   --
   /* -------------------------------------------------------------
   || p_expirar_qr: Expira manualmente el qr
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_expirar_qr ( p_id_qr          IN    qr_token.id_qr    %TYPE    ,
                            p_cod_result    OUT    NUMBER                     ,
                            p_msg_result    OUT    VARCHAR2                   );
   --
   /* -------------------------------------------------------------
   || f_validar_qr: Valida el qr(Retorna 1 = válido, 0 = no válido)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_qr ( p_codigo_qr    IN    qr_token.codigo_qr   %TYPE    ,
                           p_id_sede     OUT    qr_token.id_sede     %TYPE    ,
                           p_cod_result  OUT    NUMBER                        ,
                           p_msg_result  OUT    VARCHAR2                      )
   --
   RETURN BOOLEAN;
   --
   /* -------------------------------------------------------------
   || f_qr_activo_sede: Retorna el QR activo de la sede
   ----------------------------------------------------------------*/
   --
   FUNCTION f_qr_activo_sede ( p_id_sede         IN   qr_token.id_sede  %TYPE ,
                               p_cod_result     OUT   NUMBER                  ,
                               p_msg_result     OUT   VARCHAR2                ) 
   --
   RETURN SYS_REFCURSOR;
   --
END k_qr_token;
create or replace PACKAGE BODY k_qr_token
AS
   /*------------------------ Version 1.00 ------------------------*/
   --
   /*------------------------ Descripción -------------------------
   ||
   || Package responsable de la gestión del qr/token para el módulo
   || de asistencia.
   ----------------------------------------------------------------*/
   --
   /*------------------------ Modificación ------------------------
   ||
   || 08/12/2025 -- AJSILVA -- 1.00
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   ||                      SECCIÓN DE QR TOKEN
   ----------------------------------------------------------------*/
   --
   /* -------------------------------------------------------------
   || p_invalidar_qr_sede: Expira todos los qr activos de una sede
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_invalidar_qr_sede ( p_id_sede      IN     qr_token.id_sede   %TYPE     ,
                                   p_cod_result  OUT     NUMBER                       ,
                                   p_msg_result  OUT     VARCHAR2                     )
   --
   IS
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      UPDATE qr_token
      SET mca_estado = 'E'
      WHERE id_sede = p_id_sede
        AND mca_estado = 'A';
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'LOS QR DE LA SEDE ' || p_id_sede || ' HAN SIDO INVALIDADOS'   ;
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
   END p_invalidar_qr_sede;
   --
   /* -------------------------------------------------------------
   || p_generar_qr: Genera el qr
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_generar_qr ( p_id_sede      IN   qr_token.id_sede    %TYPE    ,
                            p_minutos      IN   NUMBER                       ,
                            p_id_qr       OUT   qr_token.id_qr      %TYPE    ,
                            p_codigo_qr   OUT   qr_token.codigo_qr  %TYPE    ,
                            p_cod_result  OUT   NUMBER                       ,
                            p_msg_result  OUT   VARCHAR2                     )
   --
   IS
      --
      l_fec_generado    qr_token.fec_generado   %TYPE    ;
      l_fec_expira      qr_token.fec_expira     %TYPE    ;
      l_mca_estado      qr_token.mca_estado     %TYPE    ;
      --
      l_p_cod_result    NUMBER                           ;
      l_p_msg_result    VARCHAR2(2000)                   ;
      --
      l_cod_result      NUMBER                           ;
      l_msg_result      VARCHAR2(2000)                   ;
      --
   BEGIN
      --
      l_p_cod_result    := 0  ;
      l_p_msg_result    := 'PROCESO INTERNO EJECUTADO EXITOSAMENTE' ;
      --
      l_cod_result      := 0  ;
      l_msg_result      := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      l_fec_generado    := SYSDATE  ;
      l_fec_expira      := l_fec_generado + (p_minutos / 1440) ;
      l_mca_estado      := 'A'      ;
      --
      IF p_minutos IS NULL OR p_minutos <= 0 THEN
         --
         p_cod_result := 1;
         p_msg_result := 'EL TIEMPO EN MINUTOS DEBE SER MAYOR A CERO';
         RETURN;
         --
      END IF;
      --
      IF NOT k_sede.f_validar_sede( p_id_sede      =>    p_id_sede      , 
                                    p_cod_result   =>    l_cod_result   , 
                                    p_msg_result   =>    l_msg_result   ) 
      THEN
         --
         p_cod_result := 0;
         p_msg_result := l_msg_result;
         RETURN;
         --
      END IF;
      --
      p_invalidar_qr_sede( p_id_sede    =>   p_id_sede      ,
                           p_cod_result =>   l_p_cod_result ,
                           p_msg_result =>   l_p_msg_result );
      IF l_p_cod_result = 2 THEN
         --
         p_cod_result := 2;
         p_msg_result := 'ERROR al invalidar QR anterior: ' || l_p_msg_result;
         RETURN;
         -- 
      END IF;
      p_id_qr        := seq_qr_token.NEXTVAL                         ;
      p_codigo_qr    := DBMS_RANDOM.STRING('A', 200)                 ;
      --
      INSERT INTO qr_token
         (
            id_qr          ,
            codigo_qr      ,
            fec_generado   ,
            fec_expira     ,
            id_sede        ,
            mca_estado
         )
      VALUES
         (
            p_id_qr        ,
            p_codigo_qr    ,
            l_fec_generado ,
            l_fec_expira   ,
            p_id_sede      ,
            l_mca_estado
         );
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'NUEVO QR GENERADO CON EXITO - ID: ' || p_id_qr  ;
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
   END p_generar_qr;
   --
   /* -------------------------------------------------------------
   || p_expirar_qr: Expira manualmente el qr
   ----------------------------------------------------------------*/
   --
   PROCEDURE p_expirar_qr ( p_id_qr        IN   qr_token.id_qr    %TYPE    ,
                            p_cod_result  OUT   NUMBER                     ,
                            p_msg_result  OUT   VARCHAR2                   )
   --
   IS
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'PROCESO EJECUTADO EXITOSAMENTE' ;
      --
      UPDATE qr_token
      SET mca_estado = 'E'
      WHERE id_qr = p_id_qr;
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'EL QR '|| p_id_qr || ' HA QUEDADO INVALIDO' ;
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
   END p_expirar_qr;
   --
   /* -------------------------------------------------------------
   || f_validar_qr: Valida el qr(Retorna 1 = válido, 0 = no válido)
   ----------------------------------------------------------------*/
   --
   FUNCTION f_validar_qr ( p_codigo_qr    IN    qr_token.codigo_qr   %TYPE    ,
                           p_id_sede     OUT    qr_token.id_sede     %TYPE    ,
                           p_cod_result  OUT    NUMBER                        ,
                           p_msg_result  OUT    VARCHAR2                      )
   --
   RETURN BOOLEAN
   --
   IS
      --
      l_fec_expira      qr_token.fec_expira     %TYPE    ;
      --
      l_cod_result      NUMBER         ;
      l_msg_result      VARCHAR2(2000) ;
      --
   BEGIN
      --
      l_cod_result   := 0  ;
      l_msg_result   := 'FUNCION EJECUTADA EXITOSAMENTE' ;
      --
      l_fec_expira   := SYSDATE  ;
      --
      SELECT id_sede, fec_expira
      INTO p_id_sede, l_fec_expira
      FROM qr_token
      WHERE codigo_qr = p_codigo_qr
        AND mca_estado = 'A';
      --
      IF l_fec_expira < SYSDATE THEN
         --
         UPDATE qr_token
         SET mca_estado = 'E'
         WHERE codigo_qr = p_codigo_qr;
         --
         p_cod_result := 1;
         p_msg_result := 'EL QR CONSULTADO NO ES VÁLIDO';
         RETURN FALSE;
         --
      END IF;
      --
      l_cod_result   := 1  ;
      l_msg_result   := 'EL QR CONSULTADO ES VÁLIDO'  ;
      --
      p_cod_result   := l_cod_result   ;
      p_msg_result   := l_msg_result   ;
      --
      RETURN TRUE;
      --
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         --
         p_cod_result := 1;
         p_msg_result := 'EL QR CONSULTADO NO ES VÁLIDO';
         RETURN FALSE;
         --
      WHEN OTHERS THEN
         --
         p_cod_result   := 2 ;
         p_msg_result   := 'ERROR GENERAL: ' || SUBSTR(SQLERRM,1,1985) ;
         RETURN NULL;
         --
   END f_validar_qr;
   --
   /* -------------------------------------------------------------
   || f_qr_activo_sede: Retorna el QR activo de la sede
   ----------------------------------------------------------------*/
   --
   FUNCTION f_qr_activo_sede ( p_id_sede         IN   qr_token.id_sede  %TYPE ,
                               p_cod_result     OUT   NUMBER                  ,
                               p_msg_result     OUT   VARCHAR2                ) 
   --
   RETURN SYS_REFCURSOR
   --
   IS
      --
      l_cursor          SYS_REFCURSOR                ;
      l_existe          NUMBER                       ;
      l_id_qr           qr_token.id_qr      %TYPE    ;
      l_codigo_qr       qr_token.codigo_qr  %TYPE    ;
      --
      l_cod_result      NUMBER           ;
      l_msg_result      VARCHAR2(2000)   ;
      --
   BEGIN
      --
      p_cod_result := 0 ;
      p_msg_result := 'PROCESO EJECUTADO EXITOSAMENTE'   ;
      --
      SELECT COUNT(*)
      INTO l_existe
      FROM qr_token
      WHERE id_sede = p_id_sede
        AND mca_estado = 'A'
        AND fec_expira > SYSDATE;
      --
      IF l_existe > 0 THEN
         --
         OPEN l_cursor FOR
            SELECT id_qr,
                   codigo_qr,
                   id_sede,
                   fec_generado,
                   fec_expira,
                   mca_estado
            FROM qr_token
            WHERE id_sede = p_id_sede
              AND mca_estado = 'A'
              AND fec_expira > SYSDATE;
            --
            p_cod_result := 1;
            p_msg_result := 'QR ACTIVO ENCONTRADO';
            RETURN l_cursor;
         --
      END IF;
      --
      k_qr_token.p_generar_qr ( p_id_sede       =>    p_id_sede      ,
                                p_minutos       =>    5              ,
                                p_id_qr         =>    l_id_qr        ,
                                p_codigo_qr     =>    l_codigo_qr    ,
                                p_cod_result    =>    l_cod_result   ,
                                p_msg_result    =>    l_msg_result   );
      --
      IF l_cod_result <> 1 THEN
         --
         p_cod_result := l_cod_result;
         p_msg_result := l_msg_result;
         RETURN NULL;
         --
      END IF;
      --
      OPEN l_cursor FOR
         SELECT 
            id_qr          ,
            codigo_qr      ,
            id_sede        ,
            fec_generado   ,
            fec_expira     ,
            mca_estado
         FROM qr_token
         WHERE id_qr = l_id_qr;
      --
      p_cod_result := 1;
      p_msg_result := 'QR GENERADO AUTOMÁTICAMENTE';
      RETURN l_cursor;
      --
   EXCEPTION
      WHEN OTHERS THEN
         --
         p_cod_result := 2;
         p_msg_result := 'ERROR GENERAL: ' || SUBSTR(SQLERRM, 1, 1985);
         RETURN NULL;
         --
   END f_qr_activo_sede;
   --
END k_qr_token;
