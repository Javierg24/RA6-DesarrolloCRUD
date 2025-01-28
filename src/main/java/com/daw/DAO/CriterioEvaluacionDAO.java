/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.daw.DAO;

import com.daw.modelo.Asignatura;
import com.daw.modelo.CriterioEvaluacion;
import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Clase DAO para gestionar los criterios de evaluación.
 *
 * @author
 */
public class CriterioEvaluacionDAO extends Service {

    public CriterioEvaluacionDAO(ComponenteBBDD componenteBBDD) {
        super(componenteBBDD);
    }

    @Override
    public List<Object> select() {
        List<Object> criterios = new ArrayList<>();
        try {
            String query = "SELECT id_criterio, id_resultado, id_asignatura, porcentaje, nombre FROM CRITERIOS";
            this.componenteBBDD.setConsulta(query);

            if (this.componenteBBDD.ejecutarConsulta()) {
                ResultSet cursor = this.componenteBBDD.getCursor();
                while (cursor.next()) {
                    CriterioEvaluacion criterio = new CriterioEvaluacion(
                            cursor.getInt("id_criterio"),
                            cursor.getInt("id_resultado"),
                            cursor.getInt("id_asignatura"),
                            cursor.getBigDecimal("porcentaje"),
                            cursor.getString("nombre")
                    );
                    criterios.add(criterio);
                }
                this.componenteBBDD.cerrarCursor();
            }
        } catch (SQLException ex) {
            System.out.println("Error al obtener los criterios de evaluación: " + ex.getMessage());
        }
        return criterios;
    }

    @Override
    public boolean delete(int id) {
        try {
            String query = "DELETE FROM CRITERIOS WHERE id_criterio = ?";
            this.componenteBBDD.setConsulta(query);
            PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
            preparedStatement.setInt(1, id);
            int result = preparedStatement.executeUpdate();
            return result > 0;
        } catch (SQLException ex) {
            System.out.println("Error al eliminar el criterio de evaluación: " + ex.getMessage());
            return false;
        }
    }

    @Override
    public boolean insert(Object o) {
        if (o instanceof CriterioEvaluacion) {
            CriterioEvaluacion criterio = (CriterioEvaluacion) o;
            try {
                String query = "INSERT INTO CRITERIOS (id_criterio, id_resultado, id_asignatura, porcentaje, nombre) VALUES (?, ?, ?, ?, ?)";
                this.componenteBBDD.setConsulta(query);
                PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
                preparedStatement.setInt(1, criterio.getIdCriterio());
                preparedStatement.setInt(2, criterio.getIdResultado());
                preparedStatement.setInt(3, criterio.getIdAsignatura());
                preparedStatement.setBigDecimal(4, criterio.getPorcentaje());
                preparedStatement.setString(5, criterio.getNombre());
                int result = preparedStatement.executeUpdate();
                return result > 0;
            } catch (SQLException ex) {
                System.out.println("Error al insertar el criterio de evaluación: " + ex.getMessage());
                return false;
            }
        }
        return false;
    }

    @Override
    public boolean update(Object o, int id) {
        if (o instanceof CriterioEvaluacion) {
            CriterioEvaluacion criterio = (CriterioEvaluacion) o;
            try {
                String query = "UPDATE CRITERIOS SET id_resultado = ?, id_asignatura = ?, porcentaje = ?, nombre = ? WHERE id_criterio = ?";
                this.componenteBBDD.setConsulta(query);
                PreparedStatement preparedStatement = this.componenteBBDD.getConexion().prepareStatement(query);
                preparedStatement.setInt(1, criterio.getIdResultado());
                preparedStatement.setInt(2, criterio.getIdAsignatura());
                preparedStatement.setBigDecimal(3, criterio.getPorcentaje());
                preparedStatement.setString(4, criterio.getNombre());
                preparedStatement.setInt(5, id);
                int result = preparedStatement.executeUpdate();
                return result > 0;
            } catch (SQLException ex) {
                System.out.println("Error al actualizar el criterio de evaluación: " + ex.getMessage());
                return false;
            }
        }
        return false;
    }

    public static void mostrarCriterios(ComponenteBBDD com, CriterioEvaluacionDAO cedao) {
        List<Object> lista = cedao.select();
        for (Object obj : lista) {
            if (obj instanceof CriterioEvaluacion) { // Asegurarse de que sea del tipo correcto
                CriterioEvaluacion criterioEvaluacion = (CriterioEvaluacion) obj;
                System.out.println(criterioEvaluacion.toString());
            } else {
                System.out.println("Elemento desconocido en la lista: " + obj);
            }
        }
    }

    public static void main(String[] args) {
        CriterioEvaluacion actCriterioEvaluacion = new CriterioEvaluacion(2, 1, 1, BigDecimal.valueOf(20), "Teoria");
        CriterioEvaluacion insCriterioEvaluacion = new CriterioEvaluacion(6, 1, 1, BigDecimal.valueOf(60), "Examen");
        ComponenteBBDD componenteBBDD = new ComponenteBBDD();
        CriterioEvaluacionDAO criterioEvaluacionDAO = new CriterioEvaluacionDAO(componenteBBDD);
        mostrarCriterios(componenteBBDD, criterioEvaluacionDAO);
        criterioEvaluacionDAO.delete(1);
        mostrarCriterios(componenteBBDD, criterioEvaluacionDAO);
        criterioEvaluacionDAO.update(actCriterioEvaluacion, 2);
        mostrarCriterios(componenteBBDD, criterioEvaluacionDAO);
        criterioEvaluacionDAO.insert(insCriterioEvaluacion);
    }
}
