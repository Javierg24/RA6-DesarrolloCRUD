<%@page import="java.math.BigDecimal"%>
<%@page import="java.util.List"%>
<%@page import="com.daw.DAO.CriterioEvaluacionDAO"%>
<%@page import="com.daw.DAO.ComponenteBBDD"%>
<%@page import="com.daw.modelo.CriterioEvaluacion"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gestión de Criterios de Evaluación</title>
        <link href="css/stylesAs.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>        

        <%
            ComponenteBBDD componenteBBDD = new ComponenteBBDD();
            CriterioEvaluacionDAO criterioEvaluacionDAO = new CriterioEvaluacionDAO(componenteBBDD);

            String accion = request.getParameter("accion");
            if (accion != null) {
                try {
                    switch (accion) {
                        case "agregar":
                            int idCriterio = Integer.parseInt(request.getParameter("id_criterio"));
                            int idResultado = Integer.parseInt(request.getParameter("id_resultado"));
                            int idAsignatura = Integer.parseInt(request.getParameter("id_asignatura"));
                            BigDecimal porcentaje = new BigDecimal(request.getParameter("porcentaje"));
                            String nombre = request.getParameter("nombre");
                            CriterioEvaluacion nuevoCriterio = new CriterioEvaluacion(idCriterio, idResultado, idAsignatura, porcentaje, nombre);
                            criterioEvaluacionDAO.insert(nuevoCriterio);
                            break;
                        case "editar":
                            idCriterio = Integer.parseInt(request.getParameter("id_criterio"));
                            idResultado = Integer.parseInt(request.getParameter("id_resultado"));
                            idAsignatura = Integer.parseInt(request.getParameter("id_asignatura"));
                            porcentaje = new BigDecimal(request.getParameter("porcentaje"));
                            nombre = request.getParameter("nombre");
                            CriterioEvaluacion criterioEditado = new CriterioEvaluacion(idCriterio, idResultado, idAsignatura, porcentaje, nombre);
                            criterioEvaluacionDAO.update(criterioEditado, idCriterio);
                            break;
                        case "borrar":
                            idCriterio = Integer.parseInt(request.getParameter("id_criterio"));
                            criterioEvaluacionDAO.delete(idCriterio);
                            break;
                    }
                } catch (Exception e) {
                    out.println("<p class='text-danger'>Error al procesar la acción: " + e.getMessage() + "</p>");
                }
            }

            List<Object> criterios = criterioEvaluacionDAO.select();
        %>

        <h2>Lista de Criterios de Evaluación</h2>
        <div class="subject-table">
            <table>
                <thead>
                    <tr>
                        <th>ID Criterio</th>
                        <th>ID Resultado</th>
                        <th>ID Asignatura</th>
                        <th>Porcentaje</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Object obj : criterios) {
                            if (obj instanceof CriterioEvaluacion) {
                                CriterioEvaluacion criterio = (CriterioEvaluacion) obj;
                    %>
                    <tr>
                        <td><%= criterio.getIdCriterio()%></td>
                        <td><%= criterio.getIdResultado()%></td>
                        <td><%= criterio.getIdAsignatura()%></td>
                        <td><%= criterio.getPorcentaje()%></td>
                        <td><%= criterio.getNombre()%></td>
                        <td class="actions-cell">
                            <form method="get" action="criterios.jsp" class="d-inline">
                                <input type="hidden" name="accion" value="editar">
                                <input type="hidden" name="id_criterio" value="<%= criterio.getIdCriterio()%>">
                                <button type="submit" class="edit-btn">Editar</button>
                            </form>
                            <form method="get" action="criterios.jsp" class="d-inline">
                                <input type="hidden" name="accion" value="borrar">
                                <input type="hidden" name="id_criterio" value="<%= criterio.getIdCriterio()%>">
                                <button type="submit" class="delete-btn" onclick="return confirm('¿Estás seguro de borrar este criterio?');">Borrar</button>
                            </form>
                        </td>
                    </tr>
                    <% }
                        }%>
                </tbody>
            </table>
        </div>
        <div class="form-container">
            <h2>Agregar Criterio</h2>
            <form method="get" action="criterios.jsp">
                <input type="hidden" name="accion" value="agregar">
                <div class="input-group">
                    <label>ID Criterio:</label>
                    <input type="number" name="id_criterio" required>
                </div>
                <div class="input-group">
                    <label>ID Resultado:</label>
                    <input type="number" name="id_resultado" required>
                </div>
                <div class="input-group">
                    <label>ID Asignatura:</label>
                    <input type="number" name="id_asignatura" required>
                </div>
                <div class="input-group">
                    <label>Porcentaje:</label>
                    <input type="number" step="0.01" name="porcentaje" required>
                </div>
                <div class="input-group">
                    <label>Nombre:</label>
                    <input type="text" name="nombre" required>
                </div>
                <button type="submit" class="btn btn-primary">Agregar</button>
            </form>
        </div>
    </body>
</html>