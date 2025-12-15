CREATE OR REPLACE TRIGGER t_log_asistencia
AFTER INSERT OR UPDATE ON asistencia
FOR EACH ROW
DECLARE
 --
 l_accion      VARCHAR2(20) ;
 l_id_log_asistencia NUMBER    ;
 l_id_asistencia   log_asistencia.id_asistencia %TYPE ;
 l_id_usuario    log_asistencia.id_usuario  %TYPE ;
 --
BEGIN
 --
 l_accion      := NULL ;
 l_id_log_asistencia := 0  ;
 l_id_asistencia   := 0  ;
 l_id_usuario    := 0  ;
 --
 IF INSERTING THEN
   --
   l_accion := 'INSERT';
   --
 ELSIF UPDATING AND NVL(:OLD.mca_baja,'N') = NVL(:NEW.mca_baja,'N') THEN
   --
   l_accion := 'UPDATE';
   --
 ELSIF UPDATING AND :OLD.mca_baja = 'N' AND :NEW.mca_baja = 'S' THEN
   --
   l_accion := 'DELETE_LOGICO';
   --
 END IF;
 --
 l_id_log_asistencia := seq_log_asistencia.NEXTVAL         ;
 l_id_asistencia   := NVL(:NEW.id_asistencia, :OLD.id_asistencia) ;
 l_id_usuario    := NVL(:NEW.id_usuario, :OLD.id_usuario)    ;
 --
 INSERT INTO log_asistencia
   (
    id_log_asistencia  ,
    id_asistencia    ,
    id_usuario     ,
    accion       ,
    fec_accion
   )
 VALUES
   (
    l_id_log_asistencia ,
    l_id_asistencia   ,
    l_id_usuario    ,
    l_accion      ,
    SYSDATE
   );
 --
END;
/
CREATE OR REPLACE TRIGGER t_log_justificacion
AFTER INSERT OR UPDATE ON justificacion
FOR EACH ROW
DECLARE
 --
 l_accion        VARCHAR2(20) ;
 l_id_log_justificacion NUMBER    ;
 l_id_justificacion   log_justificacion.id_justificacion %TYPE ;
 l_id_usuario      log_justificacion.id_usuario    %TYPE ;
 --
BEGIN
 --
 l_accion        := NULL ;
 l_id_log_justificacion := 0  ;
 l_id_justificacion   := 0  ;
 l_id_usuario      := 0  ;
 --
 IF INSERTING THEN
   --
   l_accion := 'INSERT';
   --
 ELSIF UPDATING AND NVL(:OLD.mca_baja,'N') = NVL(:NEW.mca_baja,'N') THEN
   --
   l_accion := 'UPDATE';
   --
 ELSIF UPDATING AND :OLD.mca_baja = 'N' AND :NEW.mca_baja = 'S' THEN
   --
   l_accion := 'DELETE_LOGICO';
   --
 END IF;
 --
 l_id_log_justificacion := seq_log_justificacion.NEXTVAL           ;
 l_id_justificacion   := NVL(:NEW.id_justificacion, :OLD.id_justificacion) ;
 l_id_usuario      := NVL(:NEW.id_usuario, :OLD.id_usuario)       ;
 --
 INSERT INTO log_justificacion
   (
    id_log_justificacion  ,
    id_justificacion    ,
    id_usuario       ,
    accion         ,
    fec_accion
   )
 VALUES
   (
    l_id_log_justificacion ,
    l_id_justificacion   ,
    l_id_usuario      ,
    l_accion        ,
    SYSDATE
   );
 --
END;