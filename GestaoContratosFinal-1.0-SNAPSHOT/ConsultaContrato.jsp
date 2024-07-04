<%@ page import="java.io.*, java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.*, org.json.JSONObject" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Consulta de Contrato</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/style.css">  
    <script>
        function submitForm(event) {
            event.preventDefault();
            var form = document.getElementById('consultaForm');
            var formData = new FormData(form);

            var xhr = new XMLHttpRequest();
            xhr.open('GET', 'ConsultaContrato.jsp?' + new URLSearchParams(formData).toString(), true);
            xhr.onload = function () {
                if (xhr.status === 200) {
                    document.getElementById('results').innerHTML = xhr.responseText;
                } else {
                    document.getElementById('results').innerText = 'Erro ao buscar contrato.';
                }
            };
            xhr.send();
        }
    </script>
</head>
<body>
    <h1>Consulta de Contrato</h1>
    <form id="consultaForm" onsubmit="submitForm(event)" method="get">
        <label for="nomeContrato">Nome do Contrato:</label>
        <input type="text" id="nomeContrato" name="nomeContrato"><br>
        
        <label for="descricaoContrato">Descrição do Contrato:</label>
        <textarea id="descricaoContrato" name="descricaoContrato"></textarea><br>
        
        <label for="dataInicio">Data de início:</label>
        <input type="date" id="dataInicio" name="dataInicio"><br><br>
        
        <label for="dataTermino">Data de término:</label>
        <input type="date" id="dataTermino" name="dataTermino"><br><br><br>
        
        <input type="submit" value="Buscar">
    </form>
    <div id="results"></div> <!-- Adicionado ID results -->

    <%
        String nomeContrato = "";
        String descricaoContrato = "";
        String dataInicio = "";
        String dataTermino = "";
        String contentType = request.getContentType();

        if ("GET".equalsIgnoreCase(request.getMethod())) {
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
                nomeContrato = json.optString("nomeContrato");
                descricaoContrato = json.optString("descricaoContrato");
                dataInicio = json.optString("dataInicio");
                dataTermino = json.optString("dataTermino");
            } else {
                // Processar form-urlencoded
                nomeContrato = request.getParameter("nomeContrato");
                descricaoContrato = request.getParameter("descricaoContrato");
                dataInicio = request.getParameter("dataInicio");
                dataTermino = request.getParameter("dataTermino");
            }

            List<String[]> resultados = new ArrayList<>();

            try {
                String url = "jdbc:mysql://localhost:3306/Projeto_Gestao_Contratos_Etapa_5";
                String usuario = "root";
                String senha = "=senaCEad2022";

                StringBuilder consultaSQL = new StringBuilder("SELECT * FROM Contratos WHERE 1=1");

                if (nomeContrato != null && !nomeContrato.isEmpty()) {
                    consultaSQL.append(" AND nome_contrato LIKE ?");
                }

                if (descricaoContrato != null && !descricaoContrato.isEmpty()) {
                    consultaSQL.append(" AND descricao_contrato LIKE ?");
                }

                if (dataInicio != null && !dataInicio.isEmpty()) {
                    consultaSQL.append(" AND data_inicio = ?");
                }

                if (dataTermino != null && !dataTermino.isEmpty()) {
                    consultaSQL.append(" AND data_termino = ?");
                }

                try (Connection connection = DriverManager.getConnection(url, usuario, senha);
                     PreparedStatement preparedStatement = connection.prepareStatement(consultaSQL.toString())) {

                    int parametroIndex = 1;

                    if (nomeContrato != null && !nomeContrato.isEmpty()) {
                        preparedStatement.setString(parametroIndex++, "%" + nomeContrato + "%");
                    }

                    if (descricaoContrato != null && !descricaoContrato.isEmpty()) {
                        preparedStatement.setString(parametroIndex++, "%" + descricaoContrato + "%");
                    }

                    if (dataInicio != null && !dataInicio.isEmpty()) {
                        preparedStatement.setString(parametroIndex++, dataInicio);
                    }

                    if (dataTermino != null && !dataTermino.isEmpty()) {
                        preparedStatement.setString(parametroIndex, dataTermino);
                    }

                    try (ResultSet resultSet = preparedStatement.executeQuery()) {
                        while (resultSet.next()) {
                            int idResultado = resultSet.getInt("id_contrato");
                            String nomeResultado = resultSet.getString("nome_contrato");
                            String descricaoResultado = resultSet.getString("descricao_contrato");
                            String inicioResultado = resultSet.getString("data_inicio");
                            String fimResultado = resultSet.getString("data_termino");

                            resultados.add(new String[]{String.valueOf(idResultado), nomeResultado, descricaoResultado, inicioResultado, fimResultado});
                        }
                    }
                }
            } catch (SQLException ex) {
                out.println("<p>Erro ao consultar contrato: " + ex.getMessage() + "</p>");
            }

            out.println("<html><body>");
            out.println("<h1>Resultados da Consulta de Contrato</h1>");
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Nome</th><th>Descrição</th><th>Data de Início</th><th>Data de Término</th></tr>");

            for (String[] resultado : resultados) {
                out.println("<tr>");
                for (String campo : resultado) {
                    out.println("<td>" + campo + "</td>");
                }
                out.println("</tr>");
            }

            out.println("</table>");
            out.println("</body></html>");
        }
    %>
</body>
</html>
