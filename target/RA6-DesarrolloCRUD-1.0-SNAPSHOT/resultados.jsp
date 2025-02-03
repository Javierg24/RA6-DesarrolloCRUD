<%-- 
    Document   : resultados
    Created on : 20 ene 2025, 11:56:50
    Author     : DAW2
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.daw.DAO.ResultadoAprendizajeDAO, com.daw.modelo.ResultadoAprendizaje, com.daw.DAO.ComponenteBBDD" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Resultados de Aprendizaje</title>
    <link href="css/stylesAs.css" rel="stylesheet" type="text/css"/>
</head>
<body>
    <%@ include file="include/header.jsp" %>

    <div class="container">
        <h1 class="title">Gestión de Resultados de Aprendizaje</h1>

        <div class="form-container">
            <h2 class="subtitle">Agregar Resultado de Aprendizaje</h2>
            <form method="post" action="resultados.jsp" class="form">
                <label for="idResultado">ID Resultado:</label>
                <input type="number" name="idResultado" id="idResultado" required class="input"><br>

                <label for="idAsignatura">ID Asignatura:</label>
                <input type="number" name="idAsignatura" id="idAsignatura" required class="input"><br>

                <label for="nombre">Nombre:</label>
                <input type="text" name="nombre" id="nombre" required class="input"><br>

                <button type="submit" name="accion" value="agregar" class="btn btn-primary">Agregar</button>
            </form>
        </div>

        <div class="subject-table">
            <h2 class="subtitle">Lista de Resultados de Aprendizaje</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>ID Resultado</th>
                        <th>ID Asignatura</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        ComponenteBBDD componenteBBDD = new ComponenteBBDD();
                        ResultadoAprendizajeDAO resultadoDAO = new ResultadoAprendizajeDAO(componenteBBDD);

                        // Procesar acciones del formulario
                        String accion = request.getParameter("accion");
                        if (accion != null) {
                            if (accion.equals("agregar")) {
                                int idResultado = Integer.parseInt(request.getParameter("idResultado"));
                                int idAsignatura = Integer.parseInt(request.getParameter("idAsignatura"));
                                String nombre = request.getParameter("nombre");
                                ResultadoAprendizaje nuevoResultado = new ResultadoAprendizaje(idResultado, idAsignatura, nombre);
                                resultadoDAO.insert(nuevoResultado);
                            } else if (accion.equals("eliminar")) {
                                int idResultado = Integer.parseInt(request.getParameter("idResultado"));
                                resultadoDAO.delete(idResultado);
                            } else if (accion.equals("editar")) {
                                int idResultado = Integer.parseInt(request.getParameter("idResultado"));
                                int idAsignatura = Integer.parseInt(request.getParameter("idAsignatura"));
                                String nombre = request.getParameter("nombre");
                                ResultadoAprendizaje resultadoEditado = new ResultadoAprendizaje(idResultado, idAsignatura, nombre);
                                resultadoDAO.update(resultadoEditado, idResultado);
                            }
                        }

                        // Mostrar la lista actualizada
                        List<Object> resultados = resultadoDAO.select();
                        for (Object obj : resultados) {
                            if (obj instanceof ResultadoAprendizaje) {
                                ResultadoAprendizaje resultado = (ResultadoAprendizaje) obj;
                    %>
                    <tr>
                        <td><%= resultado.getIdResultado() %></td>
                        <td><%= resultado.getIdAsignatura() %></td>
                        <td><%= resultado.getNombre() %></td>
                        <td>
                            <!-- Botón eliminar -->
                            <form method="post" action="resultados.jsp" style="display:inline;">
                                <input type="hidden" name="idResultado" value="<%= resultado.getIdResultado() %>">
                                <button type="submit" name="accion" value="eliminar" class="btn btn-danger">Eliminar</button>
                            </form>

                            <!-- Botón editar -->
                            <form method="post" action="resultados.jsp" style="display:inline;">
                                <input type="hidden" name="idResultado" value="<%= resultado.getIdResultado() %>">
                                <input type="number" name="idAsignatura" value="<%= resultado.getIdAsignatura() %>" required class="input">
                                <input type="text" name="nombre" value="<%= resultado.getNombre() %>" required class="input">
                                <button type="submit" name="accion" value="editar" class="btn btn-edit">Editar</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
