<%-- 
    Document   : CadastroContrato
    Created on : 30 de mai. de 2024, 11:21:18
    Author     : Bruno Cezar
--%>

<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Contrato</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
        function submitForm(event) {
            event.preventDefault();
            var form = document.getElementById('cadastroForm');
            var formData = new URLSearchParams(new FormData(form)).toString();

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'CadastroContrato.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('message').innerText = xhr.responseText;
                } else {
                    document.getElementById('message').innerText = 'Erro ao cadastrar contrato.';
                }
            };
            xhr.send(formData);
        }
    </script>
</head>
<body>
    <h1>Cadastro de Contrato</h1>
    <form id="cadastroForm" onsubmit="submitForm(event)" method="post">
        <label for="nomeContrato">Nome do Contrato:</label>
        <input type="text" id="nomeContrato" name="nomeContrato" required><br>
        
        <label for="descricaoContrato">Descrição do Contrato:</label>
        <textarea id="descricaoContrato" name="descricaoContrato" required></textarea><br>
        
        <label for="dataInicio">Data de Início:</label>
        <input type="date" id="dataInicio" name="dataInicio" required><br><br>
        
        <label for="dataTermino">Data de Término:</label>
        <input type="date" id="dataTermino" name="dataTermino" required><br><br>
        
        <input type="submit" value="Cadastrar">
    </form>
    <p id="message"></p>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String nomeContrato = request.getParameter("nomeContrato");
            String descricaoContrato = request.getParameter("descricaoContrato");
            String dataInicio = request.getParameter("dataInicio");
            String dataTermino = request.getParameter("dataTermino");

            // Verificação para depuração
            out.println("<p>nomeContrato: " + nomeContrato + "</p>");
            out.println("<p>descricaoContrato: " + descricaoContrato + "</p>");
            out.println("<p>dataInicio: " + dataInicio + "</p>");
            out.println("<p>dataTermino: " + dataTermino + "</p>");

            response.setContentType("text/html;charset=UTF-8");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
                String user = "root";
                String password = "=senaCEad2022";

                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);

                String sql = "INSERT INTO Contratos (nome_contrato, descricao_contrato, data_inicio, data_termino) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, nomeContrato);
                pstmt.setString(2, descricaoContrato);
                pstmt.setString(3, dataInicio);
                pstmt.setString(4, dataTermino);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    out.println("<p>Contrato cadastrado com sucesso!</p>");
                } else {
                    out.println("<p>Erro ao cadastrar contrato.</p>");
                }
            } catch (ClassNotFoundException | SQLException e) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                out.println("<p>Erro ao cadastrar contrato: " + e.getMessage() + "</p>");
                out.println("<pre>" + sw.toString() + "</pre>");
            } finally {
                try {
                    if (pstmt != null) {
                        pstmt.close();
                    }
                    if (conn != null) {
                        conn.close();
                    }
                } catch (SQLException e) {
                    StringWriter sw = new StringWriter();
                    PrintWriter pw = new PrintWriter(sw);
                    e.printStackTrace(pw);
                    out.println("<pre>" + sw.toString() + "</pre>");
                }
            }
        }
    %>
</body>
</html>

