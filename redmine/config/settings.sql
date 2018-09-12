INSERT INTO settings(id, name, value, updated_on)
VALUES (DEFAULT,'formaldocument_location', 'Milagro', now());
INSERT INTO settings(id, name, value, updated_on)
VALUES (DEFAULT, 'formaldocument_url', 'www.gadmilagro.gob.ec', now());
INSERT INTO settings(id, name, value, updated_on)
VALUES (DEFAULT, 'formaldocument_logo', '/opt/redmine/public/logo.jpg', now());
INSERT INTO settings(id, name, value, updated_on)
VALUES (DEFAULT, 'formaldocument_location_acronym', 'M', now());
INSERT INTO settings(id, name, value, updated_on)
VALUES (DEFAULT, 'formaldocument_template_html', '<html>
    <head> 
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    </head>
    <body>
        <img align="left" height="60" width="160"  src="$LOGO$" />  
        <div align="rihgt">
            <span style="font-size: 23px;text-decoration: underline">$URL$</span><br>
            <span style="font-size: 27px">$IDENTIFICATION$</span><br>
            <span style="font-size: 27px">$DATE$</span><br>
        </div>
        <table width=100%>
            <tr>
<<<<<<< HEAD
                <td colspan="2"><span style="font-size: 17px;">$WORKFLOW$ $RELATEDTASK$</span></td>
            </tr>
            <tr>
                <td width=100 VALIGN=TOP><span style="font-size: 21px;"><b>PARA:</b></span></td>
                <td width=100><span style="font-size: 21px;">$TO$</span></td>
            </tr>
            <tr>
                <td width=100 VALIGN=TOP><span style="font-size: 21px;"><b>ASUNTO:</b></span></td>
                <td width=100><span style="font-size: 21px;">$SUBJECT$</span></td>
=======
                <td colspan="2"><span style="font-size: 23px;">$WORKFLOW$ $RELATEDTASK$</span></td>
            </tr>
            <tr>
                <td width="15%"  VALIGN=TOP><span style="font-size: 27px;"><b>PARA:</b></span></td>
                <td width="85%" style="width=100%"><span style="font-size: 27px;">$TO$</span></td>
            </tr>
            <tr>
                <td width="15%" VALIGN=TOP><span style="font-size: 27px;"><b>ASUNTO:</b></span></td>
                <td width="85%" style="width=100%"><span style="font-size: 27px;">$SUBJECT$</span></td>
>>>>>>> 230f25bdb25de12d3ab914edc1115bf392e03062
            </tr>
        </table>
        <br>
        <span style="font-size: 27px;">De mi consideraci&oacute;n:
             <br><br>
            $CONTENT$
            <br><br>
        </span> <br><br><br>
        <span style="font-size: 27px;">Atentamente,
            <br><br><br><br>
            $FROM$
        </span>
    </body>
</html>', now());
