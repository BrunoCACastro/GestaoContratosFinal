<%-- 
    Document   : CadastroTermoAditivo
    Created on : 30 de mai. de 2024, 11:27:56
    Author     : Bruno Cezar
--%>

<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Termo Aditivo</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">  
    <script>
        function submitForm(event) {
            event.preventDefault(); // Prevent the form from submitting in the traditional way
            var form = document.getElementById('cadastroForm');
            var formData = new URLSearchParams(new FormData(form)).toString();

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'CadastroTermoAditivo.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('message').innerHTML = xhr.responseText;
                } else {
                    document.getElementById('message').innerText = 'Erro ao cadastrar Termo Aditivo.';
                }
            };
            xhr.send(formData);
        }
    </script>
</head>
<body>
    <h1>Cadastro de Termo Aditivo</h1>
    <form id="cadastroForm" onsubmit="submitForm(event)" method="post">
        <label for="idContrato">ID do Contrato:</label>
        <input type="text" id="idContrato" name="idContrato" required><br>
        
        <label for="descricaoTermoAditivo">Descrição do objeto do contrato:</label>
        <textarea id="descricaoTermoAditivo" name="descricaoTermoAditivo" required></textarea><br>
        
        <label for="dataInicio">Data de início:</label>
        <input type="date" id="dataInicio" name="dataInicio" required><br><br>
        
        <label for="dataFim">Data de término:</label>
        <input type="date" id="dataFim" name="dataFim" required><br><br><br>

        <input type="submit" value="Cadastrar">
    </form>
    <p id="message"></p>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String idContrato = request.getParameter("idContrato");
            String descricaoTermoAditivo = request.getParameter("descricaoTermoAditivo");
            String dataInicio = request.getParameter("dataInicio");
            String dataFim = request.getParameter("dataFim");

            // Validação dos parâmetros
            boolean hasError = false;
            StringBuilder errorMessage = new StringBuilder();

            if (idContrato == null || idContrato.trim().isEmpty()) {
                hasError = true;
                errorMessage.append("ID do Contrato é obrigatório.<br>");
            }

            if (descricaoTermoAditivo == null || descricaoTermoAditivo.trim().isEmpty()) {
                hasError = true;
                errorMessage.append("Descrição do Termo Aditivo é obrigatória.<br>");
            }

            if (dataInicio == null || dataInicio.trim().isEmpty()) {
                hasError = true;
                errorMessage.append("Data de Início é obrigatória.<br>");
            }

            if (dataFim == null || dataFim.trim().isEmpty()) {
                hasError = true;
                errorMessage.append("Data de Término é obrigatória.<br>");
            }

            if (hasError) {
                out.println("<p>Erro ao cadastrar termo aditivo:</p>");
                out.println("<p>" + errorMessage.toString() + "</p>");
            } else {
                response.setContentType("text/html;charset=UTF-8");

                Connection conn = null;
                PreparedStatement pstmt = null;

                try {
                    String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
                    String usuario = "root";
                    String senha = "=senaCEad2022";

                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(url, usuario, senha);

                    String sql = "INSERT INTO termos_aditivos (id_contrato, descricao_termo_aditivo, data_inicio, data_fim) VALUES (?, ?, ?, ?)";
                    pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                    pstmt.setString(1, idContrato);
                    pstmt.setString(2, descricaoTermoAditivo);
                    pstmt.setString(3, dataInicio);
                    pstmt.setString(4, dataFim);

                    int rows = pstmt.executeUpdate();
                    if (rows > 0) {
                        ResultSet generatedKeys = pstmt.getGeneratedKeys();
                        if (generatedKeys.next()) {
                            int id = generatedKeys.getInt(1);
                            out.println("<p>Cadastro de termo aditivo realizado com sucesso! ID: " + id + "</p>");
                        }
                    } else {
                        out.println("<p>Erro ao cadastrar termo aditivo. Nenhuma linha afetada.</p>");
                    }
                } catch (ClassNotFoundException | SQLException e) {
                    StringWriter sw = new StringWriter();
                    PrintWriter pw = new PrintWriter(sw);
                    e.printStackTrace(pw);
                    out.println("<p>Erro ao cadastrar termo aditivo: " + e.getMessage() + "</p>");
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
        }
    %>
</body>
</html>

