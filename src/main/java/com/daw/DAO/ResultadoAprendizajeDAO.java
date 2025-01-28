/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package com.daw.DAO;

import com.daw.modelo.CriterioEvaluacion;
import com.daw.modelo.ResultadoAprendizaje;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Javier Ruiz Gomez
 */
public class ResultadoAprendizajeDAO extends Service {

    public ResultadoAprendizajeDAO(ComponenteBBDD componenteBBDD) {
        super(componenteBBDD);
    }

    @Override
    public List<Object> select() {
        List<Object> resultados = new ArrayList<>();
        try {
            String query = "SELECT id_resultado, id_asignatura, nombre FROM RESULTADOS";
            this.componenteBBDD.setConsulta(query);

            if (this.componenteBBDD.ejecutarConsulta()) {
                ResultSet cursor = this.componenteBBDD.getCursor();
                while (cursor.next()) {
                    ResultadoAprendizaje resultado = new ResultadoAprendizaje(
                        cursor.getInt("id_resultado"),
                        cursor.getInt("id_asignatura"),
                        cursor.getString("nombre")
                    );
                    resultados.add(resultado);
                }
                this.componenteBBDD.cerrarCursor();
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener los resultados de aprendizaje: " + ex.getMessage());
        }
        return resultados;
    }

    @Override
    public boolean delete(int id) {
        try {
            String query = "DELETE FROM RESULTADOS WHERE id_resultado = ?";
            this.componenteBBDD.setConsulta(query);
            PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
            preparedStatement.setInt(1, id);
            int result = preparedStatement.executeUpdate();
            return result > 0;
        } catch (SQLException ex) {
            System.out.println("Error al eliminar el resultado de aprendizaje: " + ex.getMessage());
            return false;
        }
    }

    @Override
    public boolean insert(Object o) {
        if (o instanceof ResultadoAprendizaje) {
            ResultadoAprendizaje resultado = (ResultadoAprendizaje) o;
            try {
                String query = "INSERT INTO RESULTADOS (id_resultado, id_asignatura, nombre) VALUES (?, ?, ?)";
                this.componenteBBDD.setConsulta(query);
                PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
                preparedStatement.setInt(1, resultado.getIdResultado());
                preparedStatement.setInt(2, resultado.getIdAsignatura());
                preparedStatement.setString(3, resultado.getNombre());
                int result = preparedStatement.executeUpdate();
                return result > 0;
            } catch (SQLException ex) {
                System.out.println("Error al insertar el resultado de aprendizaje: " + ex.getMessage());
                return false;
            }
        }
        return false;
    }

    @Override
    public boolean update(Object o, int id) {
        if (o instanceof ResultadoAprendizaje) {
            ResultadoAprendizaje resultado = (ResultadoAprendizaje) o;
            try {
                String query = "UPDATE RESULTADOS SET id_asignatura = ?, nombre = ? WHERE id_resultado = ?";
                this.componenteBBDD.setConsulta(query);
                PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
                preparedStatement.setInt(1, resultado.getIdAsignatura());
                preparedStatement.setString(2, resultado.getNombre());
                preparedStatement.setInt(3, id);
                int result = preparedStatement.executeUpdate();
                return result > 0;
            } catch (SQLException ex) {
                System.out.println("Error al actualizar el resultado de aprendizaje: " + ex.getMessage());
                return false;
            }
        }
        return false;
    }
    
        public static void mostrarResultadoAprendizaje(ComponenteBBDD com, ResultadoAprendizajeDAO resultadoAprendizajeDAO) {
        List<Object> lista = resultadoAprendizajeDAO.select();
        for (Object obj : lista) {
            if (obj instanceof ResultadoAprendizaje) { // Asegurarse de que sea del tipo correcto
                ResultadoAprendizaje resultadoAprendizaje = (ResultadoAprendizaje) obj;
                System.out.println(resultadoAprendizaje.toString());
            } else {
                System.out.println("Elemento desconocido en la lista: " + obj);
            }
        }
    }
    
    public static void main(String[] args) {
        ResultadoAprendizaje resultadoAprendizaje = new ResultadoAprendizaje(7, 1, "RA6-Arquitectura Software");
        ResultadoAprendizaje resultadoAprendizajeAct = new ResultadoAprendizaje(2, 1, "RA2-CRUD");
        ComponenteBBDD componenteBBDD = new ComponenteBBDD();
        ResultadoAprendizajeDAO resultadoAprendizajeDAO = new ResultadoAprendizajeDAO(componenteBBDD);
        mostrarResultadoAprendizaje(componenteBBDD, resultadoAprendizajeDAO);
        resultadoAprendizajeDAO.delete(1);        
        resultadoAprendizajeDAO.insert(resultadoAprendizaje);
        resultadoAprendizajeDAO.update(resultadoAprendizajeAct, 2);              
        mostrarResultadoAprendizaje(componenteBBDD, resultadoAprendizajeDAO);
    }
}