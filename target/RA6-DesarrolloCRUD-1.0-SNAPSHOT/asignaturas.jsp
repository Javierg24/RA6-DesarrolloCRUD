<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.daw.DAO.AsignaturaDAO, com.daw.modelo.Asignatura, com.daw.DAO.ComponenteBBDD" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestión de Asignaturas</title>
    <link rel="stylesheet" href="">
</head>
<body>
    <%@ include file="include/header.jsp" %>
    <h1>Gestión de Asignaturas</h1>

    <div>
        <h2>Agregar Asignatura</h2>
        <form method="post" action="asignaturas.jsp">
            <label for="idAsignatura">ID Asignatura:</label>
            <input type="number" name="idAsignatura" id="idAsignatura" required><br>

            <label for="nombre">Nombre:</label>
            <input type="text" name="nombre" id="nombre" required><br>

            <button type="submit" name="accion" value="agregar">Agregar</button>
        </form>
    </div>

    <div>
        <h2>Lista de Asignaturas</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>ID Asignatura</th>
                    <th>Nombre</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <% 
                    // Crear instancia del DAO y procesar acciones
                    ComponenteBBDD componenteBBDD = new ComponenteBBDD();
                    AsignaturaDAO asignaturaDAO = new AsignaturaDAO(componenteBBDD);

                    String accion = request.getParameter("accion");
                    if (accion != null) {
                        if (accion.equals("agregar")) {
                            int idAsignatura = Integer.parseInt(request.getParameter("idAsignatura"));
                            String nombre = request.getParameter("nombre");
                            Asignatura nuevaAsignatura = new Asignatura(idAsignatura, nombre);
                            asignaturaDAO.insert(nuevaAsignatura);
                        } else if (accion.equals("eliminar")) {
                            int idAsignatura = Integer.parseInt(request.getParameter("idAsignatura"));
                            asignaturaDAO.delete(idAsignatura);
                        } else if (accion.equals("editar")) {
                            int idAsignatura = Integer.parseInt(request.getParameter("idAsignatura"));
                            String nombre = request.getParameter("nombre");
                            Asignatura asignaturaEditada = new Asignatura(idAsignatura, nombre);
                            asignaturaDAO.update(asignaturaEditada, idAsignatura);
                        }
                    }

                    // Obtener y mostrar la lista actualizada
                    List<Object> asignaturas = asignaturaDAO.select();
                    for (Object obj : asignaturas) {
                        if (obj instanceof Asignatura) {
                            Asignatura asignatura = (Asignatura) obj;
                %>
                <tr>
                    <td><%= asignatura.getIdAsignatura() %></td>
                    <td><%= asignatura.getNombre() %></td>
                    <td>
                        <!-- Botón eliminar -->
                        <form method="post" action="asignaturas.jsp" style="display:inline;">
                            <input type="hidden" name="idAsignatura" value="<%= asignatura.getIdAsignatura() %>">
                            <button type="submit" name="accion" value="eliminar">Eliminar</button>
                        </form>

                        <!-- Botón editar -->
                        <form method="post" action="asignaturas.jsp" style="display:inline;">
                            <input type="hidden" name="idAsignatura" value="<%= asignatura.getIdAsignatura() %>">
                            <input type="text" name="nombre" value="<%= asignatura.getNombre() %>" required>
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
