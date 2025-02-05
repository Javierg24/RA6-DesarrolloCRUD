<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.daw.DAO.AsignaturaDAO, com.daw.modelo.Asignatura, com.daw.DAO.ComponenteBBDD" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Gestión de Asignaturas</title>    
        <link href="css/stylesAs.css" rel="stylesheet" type="text/css"/>
    </head>
    <body>
        <%@ include file="include/header.jsp" %>

        <%
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

            List<Object> asignaturas = asignaturaDAO.select();
        %>

        <h1>Gestión de Asignaturas</h1>
        <div class="subject-table">        
            <table>
                <thead>
                    <tr>
                        <th>ID Asignatura</th>
                        <th>Nombre</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Object obj : asignaturas) {
                            if (obj instanceof Asignatura) {
                                Asignatura asignatura = (Asignatura) obj;
                    %>
                    <tr>
                        <td><%= asignatura.getIdAsignatura()%></td>
                        <td><%= asignatura.getNombre()%></td>
                        <td class="actions-cell">
                            <div class="d-inline">
                                <button type="submit" class="edit-btn" onclick="abrirModal('<%= asignatura.getIdAsignatura()%>', '<%= asignatura.getNombre()%>')">Editar</button>
                            </div>
                            <form action="asignaturas.jsp" class="d-inline">
                                <input type="hidden" name="idAsignatura" value="<%= asignatura.getIdAsignatura()%>">
                                <button type="submit" name="accion" value="eliminar" class="delete-btn">Borrar</button>
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

        <div class="form-container">
            <h2>Agregar Asignatura</h2>
            <form method="post" action="asignaturas.jsp" class="subject-form">
                <div class="input-group">
                    <label for="idAsignatura">ID Asignatura:</label>
                    <input type="number" name="idAsignatura" id="idAsignatura" required>
                </div>

                <div class="input-group">
                    <label for="nombre">Nombre:</label>
                    <input type="text" name="nombre" id="nombre" required>
                </div>
                <button type="submit" name="accion" value="agregar">Agregar</button>
            </form>
        </div>

        <!-- Modal de edición -->
        <div id="modalEditar" class="modal">            
            <div class="modal-content">
                <span class="close" onclick="cerrarModal()">&times;</span>
                <h2 class="tituloModal">Editar Asignatura</h2>
                <form method="post" action="asignaturas.jsp">
                    <input type="hidden" name="idAsignatura" id="modalIdAsignatura">
                    <label class="modal-intro-nombre-label" for="modalNombre">Nombre:</label>
                    <input type="text" name="nombre" id="modalNombre" class="modal-intro-nombre" required>
                    <button type="submit" name="accion" value="editar">Guardar Cambios</button>
                </form>
            </div>
        </div>

        <script>
            function abrirModal(idAsignatura, nombre) {
                document.getElementById('modalIdAsignatura').value = idAsignatura;
                document.getElementById('modalNombre').value = nombre;
                document.getElementById('modalEditar').style.display = 'block';
            }

            function cerrarModal() {
                document.getElementById('modalEditar').style.display = 'none';
            }

            window.onclick = function (event) {
                var modal = document.getElementById('modalEditar');
                if (event.target === modal) {
                    cerrarModal();
                }
            }

        </script>

    </body>
</html>
