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
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
    <%@ include file="include/header.jsp" %>
    <h1>Gestión de Resultados de Aprendizaje</h1>

    <div>
        <h2>Agregar Resultado de Aprendizaje</h2>
        <form method="post" action="resultados.jsp">
            <label for="idResultado">ID Resultado:</label>
            <input type="number" name="idResultado" id="idResultado" required><br>

            <label for="idAsignatura">ID Asignatura:</label>
            <input type="number" name="idAsignatura" id="idAsignatura" required><br>

            <label for="nombre">Nombre:</label>
            <input type="text" name="nombre" id="nombre" required><br>

            <button type="submit" name="accion" value="agregar">Agregar</button>
        </form>
    </div>

    <div>
        <h2>Lista de Resultados de Aprendizaje</h2>
        <table border="1">
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
                            <button type="submit" name="accion" value="eliminar">Eliminar</button>
                        </form>

                        <!-- Botón editar -->
                        <form method="post" action="resultados.jsp" style="display:inline;">
                            <input type="hidden" name="idResultado" value="<%= resultado.getIdResultado() %>">
                            <input type="number" name="idAsignatura" value="<%= resultado.getIdAsignatura() %>" required>
                            <input type="text" name="nombre" value="<%= resultado.getNombre() %>" required>
                            <button type="submit" name="accion" value="editar">Editar</button>
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
</body>
</html>
