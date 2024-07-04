<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.*, org.json.JSONObject" %>
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
            event.preventDefault();
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
        
        <label for="descricaoTermoAditivo">Descrição do Termo Aditivo:</label>
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
        String contentType = request.getContentType();
        String idContrato = "";
        String descricaoTermoAditivo = "";
        String dataInicio = "";
        String dataFim = "";

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
            idContrato = json.getString("idContrato");
            descricaoTermoAditivo = json.getString("descricaoTermoAditivo");
            dataInicio = json.getString("dataInicio");
            dataFim = json.getString("dataFim");
        } else {
            // Processar form-urlencoded
            idContrato = request.getParameter("idContrato");
            descricaoTermoAditivo = request.getParameter("descricaoTermoAditivo");
            dataInicio = request.getParameter("dataInicio");
            dataFim = request.getParameter("dataFim");
        }

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

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5", "root", "=senaCEad2022");
                 PreparedStatement pstmtCheck = conn.prepareStatement("SELECT id_contrato FROM contratos WHERE id_contrato = ?");
                 PreparedStatement pstmt = conn.prepareStatement("INSERT INTO termos_aditivos (id_contrato, descricao_termo_aditivo, data_inicio, data_fim) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {

                // Verificar se o contrato existe
                pstmtCheck.setString(1, idContrato);
                try (ResultSet rsCheck = pstmtCheck.executeQuery()) {
                    if (!rsCheck.next()) {
                        out.println("<p>Erro ao cadastrar termo aditivo: Contrato não encontrado.</p>");
                    } else {
                        // Inserir termo aditivo
                        pstmt.setString(1, idContrato);
                        pstmt.setString(2, descricaoTermoAditivo);
                        pstmt.setString(3, dataInicio);
                        pstmt.setString(4, dataFim);

                        int rows = pstmt.executeUpdate();
                        if (rows > 0) {
                            try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                                if (generatedKeys.next()) {
                                    int id = generatedKeys.getInt(1);
                                    out.println("<p>Cadastro de termo aditivo realizado com sucesso! ID: " + id + "</p>");
                                }
                            }
                        } else {
                            out.println("<p>Erro ao cadastrar termo aditivo. Nenhuma linha afetada.</p>");
                        }
                    }
                }
            } catch (SQLException e) {
                StringWriter sw = new StringWriter();
                e.printStackTrace(new PrintWriter(sw));
                out.println("<p>Erro ao cadastrar termo aditivo: " + e.getMessage() + "</p>");
                out.println("<pre>" + sw.toString() + "</pre>");
            }
        }
    }
%>
</body>
</html>
