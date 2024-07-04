<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.*, org.json.JSONObject" %>
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
            var formData = new URLSearchParams(new FormData(form)).toString();

            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'CadastroEmpenho.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('message').innerHTML = xhr.responseText;
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
        <input type="number" id="valorEmpenho" name="valorEmpenho" required step="0.01"><br><br>

        <input type="submit" value="Cadastrar">
    </form>
    <p id="message"></p>

<%
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String contentType = request.getContentType();
        String numeroEmpenho = "";
        String numeroContrato = "";
        String contaContabil = "";
        String valorEmpenho = "";

        if (contentType != null && contentType.contains("application/json")) {
            // Processar JSON
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            String jsonString = sb.toString();
            JSONObject json = new JSONObject(jsonString);
            numeroEmpenho = json.getString("numeroEmpenho");
            numeroContrato = json.getString("numeroContrato");
            contaContabil = json.getString("contaContabil");
            valorEmpenho = json.get("valorEmpenho").toString();  // Tratar valor como string
        } else {
            // Processar form-urlencoded
            numeroEmpenho = request.getParameter("numeroEmpenho");
            numeroContrato = request.getParameter("numeroContrato");
            contaContabil = request.getParameter("contaContabil");
            valorEmpenho = request.getParameter("valorEmpenho");
        }

        // Validação dos parâmetros
        boolean hasError = false;
        StringBuilder errorMessage = new StringBuilder();

        if (numeroEmpenho == null || numeroEmpenho.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Número do Empenho é obrigatório.<br>");
        }

        if (numeroContrato == null || numeroContrato.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Número do Contrato é obrigatório.<br>");
        }

        if (contaContabil == null || contaContabil.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Conta Contábil é obrigatória.<br>");
        }

        if (valorEmpenho == null || valorEmpenho.trim().isEmpty()) {
            hasError = true;
            errorMessage.append("Valor do Empenho é obrigatório.<br>");
        }

        if (hasError) {
            out.println("<p>Erro ao cadastrar empenho:</p>");
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

                String sql = "INSERT INTO Empenhos_Contrato (numero_empenho, numero_contrato, conta_contabil, valor_empenho) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                pstmt.setString(1, numeroEmpenho);
                pstmt.setString(2, numeroContrato);
                pstmt.setString(3, contaContabil);
                pstmt.setString(4, valorEmpenho);

                int rows = pstmt.executeUpdate();
                if (rows > 0) {
                    ResultSet generatedKeys = pstmt.getGeneratedKeys();
                    if (generatedKeys.next()) {
                        int id = generatedKeys.getInt(1);
                        out.println("<p>Cadastro de empenho realizado com sucesso! ID: " + id + "</p>");
                    }
                } else {
                    out.println("<p>Erro ao cadastrar empenho. Nenhuma linha afetada.</p>");
                }
            } catch (ClassNotFoundException | SQLException e) {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                out.println("<p>Erro ao cadastrar empenho: " + e.getMessage() + "</p>");
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
