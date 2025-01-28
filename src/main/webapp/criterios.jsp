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
    <link rel="stylesheet" href="">
</head>
<body>
    <%@ include file="include/header.jsp" %>
    <div class="container mt-5">
        <h1>Gestión de Criterios de Evaluación</h1>

        <% 
            // Instancia de conexión y DAO
            ComponenteBBDD componenteBBDD = new ComponenteBBDD();
            CriterioEvaluacionDAO criterioEvaluacionDAO = new CriterioEvaluacionDAO(componenteBBDD);

            // Procesar acciones CRUD
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

            // Obtener lista actualizada de criterios
            List<Object> criterios = criterioEvaluacionDAO.select();
        %>

        <!-- Tabla de criterios -->
        <h2>Lista de Criterios de Evaluación</h2>
        <table class="table table-bordered">
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
                    <td><%= criterio.getIdCriterio() %></td>
                    <td><%= criterio.getIdResultado() %></td>
                    <td><%= criterio.getIdAsignatura() %></td>
                    <td><%= criterio.getPorcentaje() %></td>
                    <td><%= criterio.getNombre() %></td>
                    <td>
                        <!-- Botón editar -->
                        <form method="get" action="criterios.jsp" class="d-inline">
                            <input type="hidden" name="accion" value="editar">
                            <input type="hidden" name="id_criterio" value="<%= criterio.getIdCriterio() %>">
                            <input type="number" name="id_resultado" value="<%= criterio.getIdResultado() %>" required>
                            <input type="number" name="id_asignatura" value="<%= criterio.getIdAsignatura() %>" required>
                            <input type="number" step="0.01" name="porcentaje" value="<%= criterio.getPorcentaje() %>" required>
                            <input type="text" name="nombre" value="<%= criterio.getNombre() %>" required>
                            <button type="submit" class="btn btn-warning btn-sm">Editar</button>
                        </form>
                        <!-- Botón borrar -->
                        <form method="get" action="criterios.jsp" class="d-inline">
                            <input type="hidden" name="accion" value="borrar">
                            <input type="hidden" name="id_criterio" value="<%= criterio.getIdCriterio() %>">
                            <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('¿Estás seguro de borrar este criterio?');">Borrar</button>
                        </form>
                    </td>
                </tr>
                <% } } %>
            </tbody>
        </table>

        <!-- Formulario agregar criterio -->
        <h2>Agregar Criterio</h2>
        <form method="get" action="criterios.jsp">
            <input type="hidden" name="accion" value="agregar">
            <div class="form-group">
                <label for="id_criterio">ID Criterio:</label>
                <input type="number" id="id_criterio" name="id_criterio" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="id_resultado">ID Resultado:</label>
                <input type="number" id="id_resultado" name="id_resultado" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="id_asignatura">ID Asignatura:</label>
                <input type="number" id="id_asignatura" name="id_asignatura" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="porcentaje">Porcentaje:</label>
                <input type="number" step="0.01" id="porcentaje" name="porcentaje" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input type="text" id="nombre" name="nombre" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">Agregar</button>
        </form>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
