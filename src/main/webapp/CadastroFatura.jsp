<%-- 
    Document   : CadastroFatura
    Created on : 24 de mai. de 2024, 16:05:16
    Author     : Bruno Cezar
--%>

<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Fatura</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
        function submitForm(event) {
            event.preventDefault(); // Prevent the form from submitting in the traditional way
            var form = document.getElementById('cadastroForm');
            var formData = new FormData(form);

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'CadastroFatura.jsp', true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('message').innerText = xhr.responseText;
                } else {
                    document.getElementById('message').innerText = 'Erro ao cadastrar fatura.';
                }
            };
            xhr.send(formData);
        }
    </script>
</head>
<body>
    <h1>Cadastro de Fatura</h1>
    <form id="cadastroForm" onsubmit="submitForm(event)" method="post">
        <label for="numeroFatura">Número da fatura:</label>
        <input type="text" id="numeroFatura" name="numeroFatura" required><br>
        
        <label for="valor">Valor:</label>
        <input type="number" step="0.01" id="valor" name="valor" required><br>
        
        <label for="contratoId">ID do contrato:</label>
        <input type="text" id="contratoId" name="contratoId" required><br>
        
        <label for="dataEmissao">Data de emissão:</label>
        <input type="date" id="dataEmissao" name="dataEmissao" required><br><br>
        
        <label for="dataVencimento">Data de vencimento:</label>
        <input type="date" id="dataVencimento" name="dataVencimento" required><br><br><br>

        <input type="submit" value="Cadastrar">
    </form>
    <p id="message"></p>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String numeroFatura = request.getParameter("numeroFatura");
            String dataEmissao = request.getParameter("dataEmissao");
            String dataVencimento = request.getParameter("dataVencimento");
            String valor = request.getParameter("valor");
            String contratoId = request.getParameter("contratoId");

            response.setContentType("text/html;charset=UTF-8");

            try {
                // Carregar o driver JDBC do MySQL
                Class.forName("com.mysql.cj.jdbc.Driver");

                String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
                String usuario = "root";
                String senha = "=senaCEad2022";

                try (Connection connection = DriverManager.getConnection(url, usuario, senha)) {
                    String sql = "INSERT INTO Faturas_Contrato (numero_fatura, data_emissao, data_vencimento, valor, contrato_id) VALUES (?, ?, ?, ?, ?)";
                    try (PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                        preparedStatement.setString(1, numeroFatura);
                        preparedStatement.setString(2, dataEmissao);
                        preparedStatement.setString(3, dataVencimento);
                        preparedStatement.setDouble(4, Double.parseDouble(valor));
                        preparedStatement.setInt(5, Integer.parseInt(contratoId));

                        int rowsAffected = preparedStatement.executeUpdate();
                        if (rowsAffected > 0) {
                            ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                            if (generatedKeys.next()) {
                                int id = generatedKeys.getInt(1);
                                out.println("<p>Cadastro de fatura realizado com sucesso! ID: " + id + "</p>");
                            }
                        } else {
                            out.println("<p>Erro ao cadastrar fatura. Nenhuma linha afetada.</p>");
                        }
                    }
                }
            } catch (ClassNotFoundException | SQLException ex) {
                out.println("<p>Erro ao cadastrar fatura: " + ex.getMessage() + "</p>");
            }
        }
    %>
</body>
</html>





