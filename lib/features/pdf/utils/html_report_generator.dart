// File: lib/utils/html_report_generator.dart

import 'package:clause_verify/features/pdf/model/authenticity_report_model.dart';



class HtmlReportGenerator {
  static String generateReport(
    AuthenticityReportModel data, {
    String? logoUrl,
    String? sealUrl,
    String? photo1Url,
    String? photo2Url,
    String? photo3Url,
    String? qrCodeUrl,
    String? starUrl,
  }) {
    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>clauseverify AI Pre-Expertise Report</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Georgia', serif;
            background: #f5f5f5;
            padding: 20px;
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }

        .report-container {
            width: 210mm;
            min-height: 297mm;
            background: white;
            border: 3px solid #D4AF37;
            padding: 40px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            position: relative;
        }

        .star-decoration {
            position: absolute;
            width: 50px;
            height: 50px;
            top: 50%;
            transform: translateY(-50%);
        }
        .star-left { left: -25px; }
        .star-right { right: -25px; }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 40px;
        }

        .report-info p {
            font-size: 12px;
            color: #333;
            line-height: 1.8;
        }

        .logo-container {
            text-align: center;
        }

        .logo-icon {
            width: 80px;
            height: 80px;
            background: #1A1A1A;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 8px;
            overflow: hidden;
        }

        .logo-icon img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .logo-text {
            font-size: 18px;
            letter-spacing: 4px;
            color: #D4AF37;
            font-weight: 300;
        }

        .seal {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            border: 4px solid #D4AF37;
            background: #1A1A1A;
            overflow: hidden;
        }

        .seal img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .main-title {
            text-align: center;
            font-size: 32px;
            letter-spacing: 4px;
            color: #D4AF37;
            font-weight: 300;
            margin-bottom: 40px;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 400;
            color: #333;
            margin-bottom: 20px;
        }

        .photos-grid {
            display: flex;
            gap: 12px;
        }

        .photo-item {
            text-align: center;
        }

        .photo-box {
            width: 80px;
            height: 80px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background: #f9f9f9;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .photo-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .photo-label {
            font-size: 9px;
            color: #666;
            margin-top: 4px;
        }

        .info-row {
            display: flex;
            margin-bottom: 12px;
            font-size: 13px;
        }

        .info-label {
            width: 140px;
            color: #333;
        }

        .info-value {
            font-weight: bold;
            color: #000;
        }

        .analysis-section {
            margin-bottom: 30px;
        }

        .analysis-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #ddd;
        }

        .table-header {
            background: #F5E6D3;
            border-bottom: 1px solid #ddd;
        }

        .table-header th {
            padding: 12px 16px;
            text-align: left;
            font-weight: bold;
            font-size: 14px;
        }

        .table-row {
            border-bottom: 1px solid #ddd;
        }

        .table-row td {
            padding: 12px 16px;
            font-size: 13px;
            vertical-align: top;
        }

        .score-cell {
            text-align: center;
            font-weight: bold;
        }

        .observations-cell {
            font-size: 11px;
            line-height: 1.4;
            color: #333;
        }

        .conclusion-section {
            margin-bottom: 30px;
        }

        .conclusion-title {
            font-size: 20px;
            font-weight: 500;
            color: #333;
            margin-bottom: 12px;
        }

        .conclusion-text {
            font-size: 13px;
            color: #333;
            margin-bottom: 8px;
        }

        .highlight {
            font-weight: bold;
            font-size: 15px;
        }

        .expert-note {
            margin-bottom: 30px;
        }

        .expert-title {
            font-size: 16px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .expert-text {
            font-size: 12px;
            color: #333;
            line-height: 1.5;
            text-align: justify;
        }

        .footer {
            display: flex;
            gap: 20px;
            align-items: flex-start;
        }

        .qr-container {
            width: 120px;
            height: 120px;
            border: 1px solid #000;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: white;
        }

        .qr-container img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .qr-text {
            font-size: 8px;
            text-align: center;
            margin-top: 4px;
        }

        .disclaimer {
            flex: 1;
        }

        .disclaimer p {
            font-size: 10px;
            color: #333;
            line-height: 1.4;
            margin-bottom: 8px;
        }

        .disclaimer .italic {
            font-style: italic;
        }

        .generated-by {
            text-align: right;
            font-size: 11px;
            color: #333;
            margin-top: 12px;
        }

        .generated-by .brand {
            color: #D4AF37;
            font-weight: bold;
        }

        @media print {
            body {
                padding: 0;
                background: white;
            }
            .report-container {
                box-shadow: none;
                margin: 0;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="report-container">
        ${starUrl != null ? '<img src="$starUrl" class="star-decoration star-left" alt="star">' : ''}
        ${starUrl != null ? '<img src="$starUrl" class="star-decoration star-right" alt="star">' : ''}

        <div class="header">
            <div class="report-info">
                <p>Report ID: ${data.reportId}</p>
                <p>Date of Issue: ${data.dateOfIssue}</p>
            </div>

            <div class="logo-container">
                <div class="logo-icon">
                    ${logoUrl != null ? '<img src="$logoUrl" alt="Logo">' : ''}
                </div>
                <div class="logo-text">clauseverify</div>
            </div>

            <div class="seal">
                ${sealUrl != null ? '<img src="$sealUrl" alt="Seal">' : ''}
            </div>
        </div>

        <h1 class="main-title">AI Pre-Expertise Report</h1>

        <div class="content-grid">
            <div>
                <h2 class="section-title">Submitted Photos</h2>
                <div class="photos-grid">
                    <div class="photo-item">
                        <div class="photo-box">
                            ${photo1Url != null ? '<img src="$photo1Url" alt="Photo 1">' : ''}
                        </div>
                        <div class="photo-label">User photo 1</div>
                    </div>
                    <div class="photo-item">
                        <div class="photo-box">
                            ${photo2Url != null ? '<img src="$photo2Url" alt="Photo 2">' : ''}
                        </div>
                        <div class="photo-label">User photo 2</div>
                    </div>
                    <div class="photo-item">
                        <div class="photo-box">
                            ${photo3Url != null ? '<img src="$photo3Url" alt="Photo 3">' : ''}
                        </div>
                        <div class="photo-label">User photo 3</div>
                    </div>
                </div>
            </div>

            <div>
                <h2 class="section-title">Watch Information</h2>
                <div class="info-row">
                    <span class="info-label">Brand :</span>
                    <span class="info-value">${data.watchInfo.brand}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Model :</span>
                    <span class="info-value">${data.watchInfo.model}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Serial/Ref No. :</span>
                    <span class="info-value">${data.watchInfo.serialRefNo}</span>
                </div>
                <div class="info-row">
                    <span class="info-label">Date of Analysis:</span>
                    <span class="info-value">${data.watchInfo.dateOfAnalysis}</span>
                </div>
            </div>
        </div>

        <div class="analysis-section">
            <h2 class="section-title">Detailed Analysis</h2>
            <table class="analysis-table">
                <thead class="table-header">
                    <tr>
                        <th style="width: 20%;">Component</th>
                        <th style="width: 15%;">Match Score</th>
                        <th style="width: 65%;">Observations</th>
                    </tr>
                </thead>
                <tbody>
                    ${data.components.map((c) => '''
                    <tr class="table-row">
                        <td>${c.name}</td>
                        <td class="score-cell">${c.matchScore}%</td>
                        <td class="observations-cell">${c.observations}</td>
                    </tr>
                    ''').join('')}
                </tbody>
            </table>
        </div>

        <div class="conclusion-section">
            <h2 class="conclusion-title">Conclusion</h2>
            <p class="conclusion-text">
                Overall Authenticity Score: <span class="highlight">${data.overallScore}%</span>
            </p>
            <p class="conclusion-text">
                Verdict: <span class="highlight">${data.verdict}</span>
            </p>
        </div>

        <div class="expert-note">
            <h3 class="expert-title">Expert Note:</h3>
            <p class="expert-text">${data.expertNote}</p>
        </div>

        <div class="footer">
            <div class="qr-container">
                ${qrCodeUrl != null ? '<img src="$qrCodeUrl" alt="QR">' : ''}
                <div class="qr-text">Scan to verify this report</div>
            </div>

            <div class="disclaimer">
                <p class="italic">
                    *This report is generated by AI analysis and is not an official brand certificate. 
                    For official certification, contact the manufacturer directly.
                </p>
                <p>
                    This report and its contents are intended solely for the recipient. 
                    Unauthorized copying, distribution, or disclosure of this report, in whole or in part, 
                    is strictly prohibited. The information contained herein is confidential and may not be 
                    used for any purpose other than verifying the authenticity of the submitted watch.
                </p>
                <div class="generated-by">
                    Generated by <span class="brand">${data.generatedBy}</span> on ${data.generatedDate}
                </div>
            </div>
        </div>
    </div>
</body>
</html>
    ''';
  }
}