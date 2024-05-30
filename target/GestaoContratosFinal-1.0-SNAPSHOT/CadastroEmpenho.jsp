<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Empenho</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">
    <script>
        function submitForm(event) {
            event.preventDefault(); // Prevent the form from submitting in the traditional way
            var form = document.getElementById('cadastroForm');
            var formData = new FormData(form);

            // Debugging: Log form data
            for (var pair of formData.entries()) {
                console.log(pair[0]+ ': ' + pair[1]);
            }

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'CadastroEmpenho.jsp', true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('message').innerText = xhr.responseText;
                } else {
                    document.getElementById('message').innerText = 'Erro ao cadastrar empenho.';
                }
            };
            xhr.send(formData);
        }
    </script>
</head>
<body>
    <h1>Cadastro de Empenho</h1>
    <form id="cadastroForm" onsubmit="submitForm(event)" method="post">
        <label for="numeroEmpenho">Número do Empenho:</label>
        <input type="text" id="numeroEmpenho" name="numeroEmpenho" required><br>
        
        <label for="numeroContrato">Número do Contrato:</label>
        <input type="text" id="numeroContrato" name="numeroContrato" required><br>
        
        <label for="contaContabil">Conta Contábil:</label>
        <input type="text" id="contaContabil" name="contaContabil" required><br>
        
        <label for="valorEmpenho">Valor do Empenho:</label>
        <input type="number" step="0.01" id="valorEmpenho" name="valorEmpenho" required><br><br>

        <input type="submit" value="Cadastrar">
    </form>
    <p id="message"></p>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String numeroEmpenho = request.getParameter("numeroEmpenho");
            String numeroContrato = request.getParameter("numeroContrato");
            String contaContabil = request.getParameter("contaContabil");
            String valorEmpenho = request.getParameter("valorEmpenho");

            // Debugging: Print parameters to server log
            System.out.println("NumeroEmpenho: " + numeroEmpenho);
            System.out.println("NumeroContrato: " + numeroContrato);
            System.out.println("ContaContabil: " + contaContabil);
            System.out.println("ValorEmpenho: " + valorEmpenho);

            response.setContentType("text/html;charset=UTF-8");

            // Verificar se todos os parâmetros foram recebidos corretamente
            if (numeroEmpenho == null || numeroEmpenho.trim().isEmpty() ||
                numeroContrato == null || numeroContrato.trim().isEmpty() ||
                contaContabil == null || contaContabil.trim().isEmpty() ||
                valorEmpenho == null || valorEmpenho.trim().isEmpty()) {
                out.println("<p>Todos os campos são obrigatórios.</p>");
            } else {
                try {
                    // Carregar o driver JDBC do MySQL
                    Class.forName("com.mysql.cj.jdbc.Driver");

                    String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
                    String usuario = "root";
                    String senha = "=senaCEad2022";

                    try (Connection connection = DriverManager.getConnection(url, usuario, senha)) {
                        String sql = "INSERT INTO Empenhos_Contrato (numero_empenho, numero_contrato, conta_contabil, valor_empenho) VALUES (?, ?, ?, ?)";
                        try (PreparedStatement preparedStatement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                            preparedStatement.setString(1, numeroEmpenho);
                            preparedStatement.setString(2, numeroContrato);
                            preparedStatement.setString(3, contaContabil);
                            preparedStatement.setDouble(4, Double.parseDouble(valorEmpenho));

                            int rowsAffected = preparedStatement.executeUpdate();
                            if (rowsAffected > 0) {
                                ResultSet generatedKeys = preparedStatement.getGeneratedKeys();
                                if (generatedKeys.next()) {
                                    int id = generatedKeys.getInt(1);
                                    out.println("<p>Cadastro de empenho realizado com sucesso! ID: " + id + "</p>");
                                }
                            } else {
                                out.println("<p>Erro ao cadastrar empenho. Nenhuma linha afetada.</p>");
                            }
                        }
                    }
                } catch (ClassNotFoundException | SQLException ex) {
                    out.println("<p>Erro ao cadastrar empenho: " + ex.getMessage() + "</p>");
                }
            }
        }
    %>
</body>
</html>
