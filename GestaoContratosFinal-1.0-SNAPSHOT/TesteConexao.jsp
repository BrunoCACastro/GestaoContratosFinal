<%-- 
    Document   : TesteConexao
    Created on : 24 de mai. de 2024, 19:06:58
    Author     : Bruno Cezar
--%>

<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Verificação da Conexão com o Banco de Dados</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
    <h1>Verificação da Conexão com o Banco de Dados</h1>

    <%
        // Configurações do banco de dados
        String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
        String usuario = "root";
        String senha = "=senaCEad2022";
        String mensagem = "";

        // Carregar o driver JDBC do MySQL
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            mensagem = "Erro ao carregar o driver JDBC: " + e.getMessage();
        }

        // Verificar conexão com o banco de dados
        if (mensagem.isEmpty()) {
            try (Connection connection = DriverManager.getConnection(url, usuario, senha)) {
                if (connection != null) {
                    mensagem = "Conexão com o banco de dados estabelecida com sucesso!";
                } else {
                    mensagem = "Falha ao estabelecer a conexão com o banco de dados.";
                }
            } catch (SQLException ex) {
                mensagem = "Erro ao conectar ao banco de dados: " + ex.getMessage();
            }
        }

        // Exibir a mensagem de verificação
        out.println("<p>" + mensagem + "</p>");
    %>
</body>
</html>


