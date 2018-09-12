-- Function: find_issue_by_cedula(character varying, boolean)

-- DROP FUNCTION find_issue_by_cedula(character varying, boolean);

CREATE OR REPLACE FUNCTION find_issue_by_cedula(
    IN cedula character varying,
    IN estado boolean,
    OUT codigo integer,
    OUT tracker character varying,
    OUT project character varying,
    OUT subject character varying,
    OUT status character varying,
    OUT assigned_to text,
    OUT author text,
    OUT is_closed boolean,
    OUT created_on timestamp without time zone,
    OUT closed_on timestamp without time zone)
  RETURNS SETOF record AS
$BODY$begin
return query select i.id,t.name,p.name,i.subject,iss.name,
     (select lastname||' '||firstname from users u where id = i.assigned_to_id),
     (select lastname||' '||firstname from users u where id = i.author_id),
     iss.is_closed,i.created_on,i.closed_on 
     from trackers t,projects p, issue_statuses iss,issues i,custom_values cv   
     where i.tracker_id=t.id and i.project_id=p.id and i.status_id=iss.id 
     and (i.id=cv.customized_id and cv.custom_field_id=2) --2 = id del  custom_fields que tiene la cedula
     and cv.value = $1 --cedula del cliente
     and iss.is_closed = $2 -- permite definir si deben ser resueltas o no
     order by i.id;
     
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION find_issue_by_cedula(character varying, boolean)
  OWNER TO postgres;
-- Function: "find_issue_for_suspension_agua(idabonado text, id int4, tipo va"(text)

-- DROP FUNCTION "find_issue_for_suspension_agua(idabonado text, id int4, tipo va"(text);

CREATE OR REPLACE FUNCTION "find_issue_for_suspension_agua(idabonado text, id int4, tipo va"(
    IN idabonado text,
    OUT id integer,
    OUT tipo character varying)
  RETURNS SETOF record AS
$BODY$begin
return query select i.id ,t.name from custom_values as cv,issues as i,issue_statuses as iss,trackers as t
    where (i.id=cv.customized_id)
    and (i.status_id=iss.id)
    and (i.tracker_id=t.id)
    and cv.custom_field_id = 10  --codigo de la peticion
    and cv.value = $1   --cuenta del abonado
    and is_closed = false --peticion abierta
    and i.project_id in (select p.id from projects p  where  parent_id  = 5 and status = 1) --codigo del proyecto padre donde se va a consultar
    and i.tracker_id in (459);  --- tipo de solicitud;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION "find_issue_for_suspension_agua(idabonado text, id int4, tipo va"(text)
  OWNER TO postgres;
-- Function: fn_formaldocument_get_from(integer, integer)

-- DROP FUNCTION fn_formaldocument_get_from(integer, integer);

CREATE OR REPLACE FUNCTION fn_formaldocument_get_from(
    idissue integer,
    idjournal integer)
  RETURNS text AS
$BODY$
  DECLARE _TO text;
begin
    select into _TO academic_title||' '||firstname||' '||lastname||'<br><b>'||"position"||'</b>' from users 
    where id = (select (CASE WHEN $2 = 0 THEN (select author_id from issues where id =$1) ELSE (select user_id from journals where id=$2) END));
    RETURN _TO;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fn_formaldocument_get_from(integer, integer)
  OWNER TO postgres;
-- Function: fn_formaldocument_get_html(integer, integer)

-- DROP FUNCTION fn_formaldocument_get_html(integer, integer);

CREATE OR REPLACE FUNCTION fn_formaldocument_get_html(
    issueid integer,
    journalid integer)
  RETURNS text AS
$BODY$
declare _TEMPLATE_HTML text;
    _LOCATION TEXT;
    _LOCATION_ACRONYM TEXT;
    _LOGO TEXT;
    _URL TEXT;
    _IDENTIFICATION TEXT;
    _DATE TEXT;
    _TO TEXT;
    _SUBJECT TEXT;
    _CONTENT TEXT;
    _FROM TEXT;
    _WORKFLOW TEXT;
    _RELATEDTASK TEXT;
begin
  --ASIGNACION DE VARIABLES
  select into _TEMPLATE_HTML value from settings  where name like 'formaldocument_template_html';
  select into _LOCATION  value from settings  where name like 'formaldocument_location';
  select into _LOCATION_ACRONYM  value from settings  where name like 'formaldocument_location_acronym';
  select into _LOGO value from settings  where name like 'formaldocument_logo';
  select into _URL value from settings  where name like 'formaldocument_url';
  select   
    (select (CASE WHEN t.id = 4 THEN UPPER(t.name) ELSE 'OFICIO' END)--4 SIEMPRE PARA MEMORANDUM ,6 SIEMPRE PARA SOLICITUDES
        ||' Nro. GADM'||_LOCATION_ACRONYM||'-'||cv.value||'-'||
        (select substring((select cast(i.updated_on as text)) from 1 for 5))
        ||cast(i.id as text)||(CASE WHEN $2 > 0 THEN ('-'||cast($2 as text)) ELSE ('') END)||
        (select (CASE WHEN t.id = 4 THEN '-M' ELSE '-O' END))
        from trackers t,custom_values cv where
          t.id = i.tracker_id 
          and customized_type like 'Project' 
          and custom_field_id = 18 --Siglas de proyecto
          and customized_id = i.project_id) --IDENTIFICACION DOCUMENTO

    ,(SELECT (CASE WHEN $2 = 0 THEN (select fn_get_fecha_cdmy(_LOCATION,((select case WHEN (select count(id) from journals where journalized_id = $1) > 0 
                        then (select jd.created_on from journals jd where jd.journalized_id = $1 order by id desc limit 1) 
                        else i.created_on end)))) 
              ELSE (select fn_get_fecha_cdmy(_LOCATION,(select j.created_on from journals j WHERE id=$2))) END)) --FECHA CREACION-ACTUALIZACION
    

    ,(SELECT (CASE WHEN i.tracker_id = 4  THEN 
                (SELECT * FROM fn_formaldocument_get_to(i.id)  gd)
              ELSE
                (CASE WHEN (select string_agg(value, ' ' order by custom_field_id DESC )
                     from custom_values 
                     where UPPER(customized_type) like 'ISSUE' 
                     AND customized_id = $1 
                     AND custom_field_id  in (5,9) -- 5="Apellidos",9="Nombres"
                     group by customized_id) IS NULL
                     THEN
                  (SELECT * FROM fn_formaldocument_get_to(i.id)  gd) 
                     ELSE
                     (select string_agg(value, ' ' order by custom_field_id DESC )
                     from custom_values 
                     where UPPER(customized_type) like 'ISSUE' 
                     AND customized_id = $1 
                     AND custom_field_id  in (5,9) -- 5="Apellidos",9="Nombres"
                     group by customized_id) END)
              END)) --DESTINATARIO

  
    ,cast(subject as text) --ASUNTO

    ,(SELECT (CASE WHEN $2 = 0 THEN i.description ELSE (select j.notes from journals j where id = $2) END)) c6 --CONTENIDO

    ,(select * from fn_formaldocument_get_from($1,$2)) --DE

    ,(SELECT (CASE WHEN (i.root_id!=i.id and i.tracker_id=4) THEN 'En respuesta a #'||i.root_id||'<br>'  --TAREAS PADRE
        WHEN (i.root_id!=i.id) THEN 'Subtarea de #'||i.root_id||'<br>' 
        ELSE '' END))

    ,(SELECT (CASE WHEN (select count(id) from issue_relations WHERE issue_from_id = i.id and relation_type like 'relates')>0 --RELACIONES
        THEN '<br> Relacionado con; '||(select string_agg('#'||issue_to_id,', ' order by issue_to_id )
          from issue_relations 
          where issue_from_id = i.id 
          group by issue_from_id) ELSE '' END))
    
    into _IDENTIFICATION,_DATE,_TO,_SUBJECT,_CONTENT,_FROM,_WORKFLOW,_RELATEDTASK
    from issues i  where i.id = $1;

  --REEMPLAZO DE VARIABLES EN _TEMPLATE_HTML
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$LOGO$',_LOGO));  
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$URL$',_URL));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$IDENTIFICATION$',_IDENTIFICATION));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$DATE$',_DATE));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$TO$',_TO));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$SUBJECT$',_SUBJECT));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$CONTENT$',_CONTENT));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$FROM$',_FROM));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$WORKFLOW$',_WORKFLOW));
  _TEMPLATE_HTML = (select replace (_TEMPLATE_HTML,'$RELATEDTASK$',_RELATEDTASK));
  raise notice '(%)',_TEMPLATE_HTML;
  return _TEMPLATE_HTML;
end;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fn_formaldocument_get_html(integer, integer)
  OWNER TO postgres;
-- Function: fn_formaldocument_get_to(integer)

-- DROP FUNCTION fn_formaldocument_get_to(integer);

CREATE OR REPLACE FUNCTION fn_formaldocument_get_to(idissue integer)
  RETURNS text AS
$BODY$
  DECLARE _assigned_to_id integer;
  _cursor CURSOR FOR SELECT id,firstname,lastname,type,"position",academic_title
       from users u where u.id in (select a.user_id from assigneds a,issues i,users u where (a.user_id = u.id and a.issue_id = i.id) and i.id=$1 and a.is_deleted=false);
  _recor record;
  _destinatario text;
  _tratamiento character varying;
  _titulo character varying;
  _tipo_servidor character varying;
  _contador integer;
begin
  _assigned_to_id := (select assigned_to_id from issues where id = $1);
  IF EXISTS(select a.user_id from assigneds a,issues i,users u where (a.user_id = u.id and a.issue_id = i.id) and i.id=$1 and a.is_deleted=false) THEN       
    _contador:=0;
    FOR _recor IN _cursor LOOP
      IF _recor.type = 'User' THEN
    _tratamiento := 'Sr(a). ' ;
    _titulo := COALESCE(_recor.academic_title||' ','');
        _tipo_servidor :=  COALESCE('<br><b>'||_recor."position"||'</b>','');
      ELSIF _recor.type = 'Group' THEN  
        _tratamiento := 'Grupo de ';
        _titulo := '';
        _tipo_servidor := '';
      ELSE
    _tratamiento := '';
        _titulo := '';
        _tipo_servidor := '';
      END IF;

      IF _contador=0 THEN
        _destinatario:=_tratamiento||_titulo||_recor.firstname||' '||_recor.lastname||' '||_tipo_servidor;
      ELSE
        _destinatario:=_destinatario||'<br><br>'||(_tratamiento||_titulo||_recor.firstname||' '||_recor.lastname||' '||_tipo_servidor);
      END IF;
      _contador=_contador+1;
    END LOOP;
  ELSE
    _destinatario:= (SELECT academic_title||' '||firstname||' '||lastname||'<br><b>'||"position"||'</b>' from users u where u.id = _assigned_to_id);
  END IF;
  RETURN _destinatario;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fn_formaldocument_get_to(integer)
  OWNER TO postgres;
-- Function: fn_get_fecha_cdmy(text, timestamp without time zone)

-- DROP FUNCTION fn_get_fecha_cdmy(text, timestamp without time zone);

CREATE OR REPLACE FUNCTION fn_get_fecha_cdmy(
    localidad text,
    fecha timestamp without time zone)
  RETURNS text AS
$BODY$
declare 
  fecha_res text;
begin
  fecha_res = (select $1||', '||(select substring((cast((cast($2 as text)) as text)) from 9 for 2))||' de '||(
    SELECT (CASE 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '01' THEN 'Enero' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '02' THEN 'Febrero' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '03' THEN 'Marzo' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '04' THEN 'Abril' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '05' THEN 'Mayo' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '06' THEN 'Junio' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '07' THEN 'Julio' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '08' THEN 'Agosto' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '09' THEN 'Septiembre' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '10' THEN 'Octubre' 
      WHEN (select substring((cast($2 as text)) from 6 for 2)) like '11' THEN 'Noviembre' 
      ELSE 'Diciembre' END)
    )||' de '||(select substring((cast($2 as text)) from 1 for 4)));  
  return fecha_res; 
  --select fn_get_fecha_cdmy('Riobamba','2016-01-05')
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fn_get_fecha_cdmy(text, timestamp without time zone)
  OWNER TO postgres;
-- Function: fn_migrar_campos__personalizados_usuarios()

-- DROP FUNCTION fn_migrar_campos__personalizados_usuarios();

CREATE OR REPLACE FUNCTION fn_migrar_campos__personalizados_usuarios()
  RETURNS integer AS
$BODY$
  DECLARE _cursor CURSOR FOR select u.id,
     (select value from custom_values where customized_type like 'Principal' and custom_field_id  = 15 and customized_id = u.id limit 1) as titulo, --Titulo 
     (select value from custom_values where customized_type like 'Principal' and custom_field_id  = 16 and customized_id = u.id limit 1) as cargo --Tipo Servidor
     from users u;
    _recor record;
begin
    FOR _recor IN _cursor LOOP
      update users set academic_title = _recor.titulo, "position" = _recor.cargo where id = _recor.id;
    END LOOP;
    -- revisar datos y de ser exitosa eliminar los campos personalizados "Titulo" y "Tipo de Servidor"
RETURN 1;
end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION fn_migrar_campos__personalizados_usuarios()
  OWNER TO postgres;
