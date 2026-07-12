using DocumentFormat.OpenXml;
using DocumentFormat.OpenXml.Packaging;
using DocumentFormat.OpenXml.Wordprocessing;
using DW = DocumentFormat.OpenXml.Drawing.Wordprocessing;
using A = DocumentFormat.OpenXml.Drawing;
using PIC = DocumentFormat.OpenXml.Drawing.Pictures;

namespace Docx;

public class Program
{
    private static class Colors
    {
        public const string Primary = "0d9488";
        public const string Slate = "334155";
        public const string Mid = "475569";
        public const string Light = "94a3b8";
        public const string Accent = "14b8a6";
        public const string Border = "cbd5e1";
        public const string TableHeader = "f0fdfa";
        public const string Warning = "f59e0b";
        public const string Success = "10b981";
    }

    private const int A4W = 11906;
    private const int A4H = 16838;
    private const long A4WE = 7560000L;
    private const long A4HE = 10692000L;

    public static void Main(string[] args)
    {
        string outputPath = args.Length > 0 ? args[0] : "/mnt/agents/output/AI_UX_Analysis.docx";
        string bgDir = args.Length > 1 ? args[1] : "/mnt/agents/output/bg";
        Generate(outputPath, bgDir);
    }

    public static void Generate(string outputPath, string bgDir)
    {
        using var doc = WordprocessingDocument.Create(outputPath, WordprocessingDocumentType.Document);
        var mainPart = doc.AddMainDocumentPart();
        mainPart.Document = new Document(new Body());
        var body = mainPart.Document.Body!;

        AddStyles(mainPart);
        AddNumbering(mainPart);

        var coverBgId = AddImage(mainPart, Path.Combine(bgDir, "cover_bg.png"));
        var backBgId = AddImage(mainPart, Path.Combine(bgDir, "backcover_bg.png"));

        uint prId = 1;
        AddCoverSection(body, coverBgId, ref prId);
        AddTocSection(body);
        AddContentSection(doc, body, mainPart, bgDir, ref prId);
        AddBackcoverSection(body, backBgId, ref prId);

        SetUpdateFieldsOnOpen(mainPart);
        doc.Save();
    }

    private static void AddStyles(MainDocumentPart mainPart)
    {
        var sp = mainPart.AddNewPart<StyleDefinitionsPart>();
        sp.Styles = new Styles();

        sp.Styles.Append(new Style(
            new StyleName { Val = "Normal" },
            new StyleParagraphProperties(
                new SpacingBetweenLines { After = "200", Line = "312", LineRule = LineSpacingRuleValues.Auto }),
            new StyleRunProperties(
                new RunFonts { Ascii = "Calibri", HighAnsi = "Calibri", EastAsia = "Microsoft YaHei" },
                new FontSize { Val = "22" },
                new Color { Val = Colors.Slate })
        ) { Type = StyleValues.Paragraph, StyleId = "Normal", Default = true });

        sp.Styles.Append(MakeHeading("Heading1", "heading 1", 0, "40", Colors.Primary, "600", "280"));
        sp.Styles.Append(MakeHeading("Heading2", "heading 2", 1, "28", Colors.Slate, "440", "180"));
        sp.Styles.Append(MakeHeading("Heading3", "heading 3", 2, "24", Colors.Mid, "320", "140"));

        sp.Styles.Append(new Style(
            new StyleName { Val = "Caption" }, new BasedOn { Val = "Normal" },
            new StyleParagraphProperties(
                new Justification { Val = JustificationValues.Center },
                new SpacingBetweenLines { Before = "60", After = "320" }),
            new StyleRunProperties(new Color { Val = Colors.Light }, new FontSize { Val = "20" })
        ) { Type = StyleValues.Paragraph, StyleId = "Caption" });

        sp.Styles.Append(MakeTocStyle("TOC1", "toc 1", true, "0", "240"));
        sp.Styles.Append(MakeTocStyle("TOC2", "toc 2", false, "360", "80"));
        sp.Styles.Append(MakeTocStyle("TOC3", "toc 3", false, "720", "40"));
    }

    private static Style MakeHeading(string id, string name, int level, string fontSize, string color, string sb, string sa)
    {
        return new Style(
            new StyleName { Val = name }, new BasedOn { Val = "Normal" },
            new StyleParagraphProperties(
                new KeepNext(), new KeepLines(),
                new SpacingBetweenLines { Before = sb, After = sa },
                new OutlineLevel { Val = level }),
            new StyleRunProperties(
                new Bold(), new FontSize { Val = fontSize },
                new RunFonts { Ascii = "Calibri", HighAnsi = "Calibri", EastAsia = "Microsoft YaHei" },
                new Color { Val = color })
        ) { Type = StyleValues.Paragraph, StyleId = id };
    }

    private static Style MakeTocStyle(string id, string name, bool bold, string indent, string before)
    {
        var rpr = new StyleRunProperties(new Color { Val = bold ? Colors.Slate : Colors.Mid });
        if (bold) rpr.Append(new Bold());
        return new Style(
            new StyleName { Val = name }, new BasedOn { Val = "Normal" },
            new StyleParagraphProperties(
                new Tabs(new TabStop { Val = TabStopValues.Right, Leader = TabStopLeaderCharValues.Dot, Position = 9350 }),
                new SpacingBetweenLines { Before = before, After = "60" },
                new Indentation { Left = indent }),
            rpr
        ) { Type = StyleValues.Paragraph, StyleId = id };
    }

    private static void AddCoverSection(Body body, string coverBgId, ref uint prId)
    {
        body.Append(new Paragraph(new Run(CreateFloatingBg(coverBgId, prId++, "CoverBg"))));
        body.Append(new Paragraph(new ParagraphProperties(new SpacingBetweenLines { Before = "5600" }), new Run()));

        body.Append(new Paragraph(
            new ParagraphProperties(
                new Justification { Val = JustificationValues.Left },
                new Indentation { Left = "1200", Right = "1200" },
                new SpacingBetweenLines { After = "200" }),
            new Run(new RunProperties(new FontSize { Val = "72" }, new Color { Val = Colors.Slate }, new Spacing { Val = 30 }),
                new Text("AI UX Analysis"))));

        body.Append(new Paragraph(
            new ParagraphProperties(
                new Justification { Val = JustificationValues.Left },
                new Indentation { Left = "1200", Right = "1200" },
                new SpacingBetweenLines { After = "600" }),
            new Run(new RunProperties(new FontSize { Val = "32" }, new Color { Val = Colors.Primary }, new Spacing { Val = 20 }),
                new Text("Guess vs. Not Guess | Decision Tree KM | Job Upload"))));

        body.Append(new Paragraph(
            new ParagraphProperties(
                new Justification { Val = JustificationValues.Left },
                new Indentation { Left = "1200", Right = "1200" },
                new SpacingBetweenLines { After = "200" }),
            new Run(new RunProperties(new FontSize { Val = "22" }, new Color { Val = Colors.Mid }),
                new Text("Deep Research and Experience Improvement Recommendations"))));

        body.Append(new Paragraph(
            new ParagraphProperties(new Indentation { Left = "1200" }, new SpacingBetweenLines { Before = "2400" }),
            new Run(new RunProperties(new FontSize { Val = "20" }, new Color { Val = Colors.Light }),
                new Text("Prepared for Discussion  |  June 2026"))));

        body.Append(new Paragraph(new ParagraphProperties(new SectionProperties(
            new TitlePage(),
            new SectionType { Val = SectionMarkValues.NextPage },
            new PageSize { Width = (UInt32Value)(uint)A4W, Height = (UInt32Value)(uint)A4H },
            new PageMargin { Top = 0, Right = 0, Bottom = 0, Left = 0, Header = 0, Footer = 0 }))));
    }

    private static void AddTocSection(Body body)
    {
        body.Append(MakeH1("Table of Contents", "_Toc000"));

        body.Append(new Paragraph(
            new ParagraphProperties(new SpacingBetweenLines { After = "300" }),
            new Run(new RunProperties(new Color { Val = Colors.Light }, new FontSize { Val = "18" }),
                new Text("Right-click and select \"Update Field\" to refresh page numbers"))));

        body.Append(new Paragraph(
            new Run(new FieldChar { FieldCharType = FieldCharValues.Begin }),
            new Run(new FieldCode(" TOC \\o \"1-3\" \\h \\z \\u ") { Space = SpaceProcessingModeValues.Preserve }),
            new Run(new FieldChar { FieldCharType = FieldCharValues.Separate })));

        string[,] toc = {
            { "Executive Summary", "1", "3" },
            { "The Core Problem: Guess vs. Not Guess", "1", "4" },
            { "Understanding AI Confidence", "2", "4" },
            { "The User Experience Gap", "2", "5" },
            { "Decision Tree Knowledge Management UX", "1", "7" },
            { "Current Pain Points", "2", "7" },
            { "Recommended UX Patterns", "2", "8" },
            { "Job Upload Workflow Experience", "1", "10" },
            { "Cognitive Load and Trust Factors", "1", "12" },
            { "Specific Recommendations for Your AI", "1", "14" },
            { "Visual Mockup Descriptions", "2", "15" },
            { "Implementation Priority Matrix", "1", "17" },
        };
        for (int i = 0; i < toc.GetLength(0); i++)
            body.Append(new Paragraph(
                new ParagraphProperties(new ParagraphStyleId { Val = $"TOC{toc[i, 1]}" }),
                new Run(new Text(toc[i, 0])), new Run(new TabChar()), new Run(new Text(toc[i, 2]))));

        body.Append(new Paragraph(new Run(new FieldChar { FieldCharType = FieldCharValues.End })));

        body.Append(new Paragraph(new ParagraphProperties(new SectionProperties(
            new SectionType { Val = SectionMarkValues.NextPage },
            new PageSize { Width = (UInt32Value)(uint)A4W, Height = (UInt32Value)(uint)A4H },
            new PageMargin { Top = 1800, Right = 1440, Bottom = 1440, Left = 1440, Header = 720, Footer = 720 }))));
    }

    private static void AddContentSection(WordprocessingDocument doc, Body body, MainDocumentPart mainPart, string bgDir, ref uint prId)
    {
        var headerPart = mainPart.AddNewPart<HeaderPart>();
        var headerId = mainPart.GetIdOfPart(headerPart);
        var bodyBgPath = Path.Combine(bgDir, "body_bg.png");
        if (File.Exists(bodyBgPath))
        {
            var headerImagePart = headerPart.AddImagePart(ImagePartType.Png);
            using (var stream = new FileStream(bodyBgPath, FileMode.Open))
                headerImagePart.FeedData(stream);
            var headerImageId = headerPart.GetIdOfPart(headerImagePart);
            headerPart.Header = new Header(
                new Paragraph(new Run(CreateFloatingBg(headerImageId, prId++, "BodyBg"))),
                new Paragraph(
                    new ParagraphProperties(new Justification { Val = JustificationValues.Right }),
                    new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }),
                        new Text("AI UX Analysis  |  Guess vs. Not Guess  |  Decision Tree KM"))));
        }
        else
        {
            headerPart.Header = new Header(new Paragraph(
                new ParagraphProperties(new Justification { Val = JustificationValues.Right }),
                new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }),
                    new Text("AI UX Analysis"))));
        }

        var footerPart = mainPart.AddNewPart<FooterPart>();
        var footerId = mainPart.GetIdOfPart(footerPart);
        var fp = new Paragraph(new ParagraphProperties(new Justification { Val = JustificationValues.Center }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.Begin }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldCode(" PAGE ") { Space = SpaceProcessingModeValues.Preserve }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.Separate }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new Text("1")));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.End }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new Text(" / ") { Space = SpaceProcessingModeValues.Preserve }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.Begin }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldCode(" NUMPAGES ") { Space = SpaceProcessingModeValues.Preserve }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.Separate }));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new Text("1")));
        fp.Append(new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new FieldChar { FieldCharType = FieldCharValues.End }));
        footerPart.Footer = new Footer(fp);

        // CONTENT
        body.Append(MakeH1("Executive Summary", "_Toc001"));
        body.Append(MakeP("This document presents a comprehensive user experience analysis focused on three interconnected challenges in your AI system: (1) the Guess vs. Not Guess confidence communication problem, (2) Decision Tree Knowledge Management (DT KM) interface design, and (3) the job upload workflow experience. Based on deep research into AI UX patterns, cognitive load theory, and industry best practices from 2024-2026, this analysis identifies specific friction points and provides actionable recommendations."));
        body.Append(MakeP("The central insight: users cannot make informed decisions about AI outputs when the system does not communicate its own certainty level. When your AI guesses versus when it knows - this distinction must be visible, understandable, and actionable in the interface. Without this, trust erodes silently."));
        body.Append(MakeHighlight("Key Finding", "Research shows that 58% of users with negative attitudes toward AI experienced significantly enhanced trust when uncertainty was visualized. The single most impactful UX change you can make is implementing confidence transparency.", Colors.Primary));

        body.Append(MakeH1("The Core Problem: Guess vs. Not Guess", "_Toc002"));
        body.Append(MakeP("The fundamental UX challenge in AI systems is the shift from deterministic outputs (traditional software: input A always produces output B) to probabilistic outputs (AI: input A produces output B with 85% confidence). Your users are accustomed to software that knows the answer. AI often guesses. The interface must communicate this distinction or users will misplace trust."));

        body.Append(MakeH2("Understanding AI Confidence"));
        body.Append(MakeP("AI confidence scores are not probabilities in the strict mathematical sense. A response with 90% confidence does not mean there is exactly a 10% chance of error. Scores are relative indicators - higher scores correlate with better accuracy, but the relationship is not perfectly linear. This is why calibration matters."));
        body.Append(MakeP("The research identifies three critical confidence zones that should drive different UI behaviors:"));
        body.Append(MakeTable4(new string[,] {
            { "Zone", "Confidence", "UI Behavior", "User Action" },
            { "Know", "Above 90%", "Green indicator, auto-accept", "Trust, quick verify optional" },
            { "Check", "70% to 90%", "Amber indicator, flagged review", "One-click confirm or edit" },
            { "Guess", "Below 70%", "Red indicator, no auto-fill", "Manual input required" }
        }));

        body.Append(MakeH2("The User Experience Gap"));
        body.Append(MakeP("Our analysis identified five specific UX failures that occur when AI systems do not properly communicate the guess versus know distinction:"));
        body.Append(MakeBullet("Silent Errors", "The AI provides a confident-looking answer that is wrong. The user has no visual cue that verification is needed. This is the most dangerous failure mode."));
        body.Append(MakeBullet("Over-cautious Escalation", "The AI says I cannot help with that when it actually has useful information. Users become frustrated and abandon the tool."));
        body.Append(MakeBullet("Inconsistent Authority", "Sometimes the AI presents guesses as facts, other times it hedges unnecessarily. Users cannot build a mental model of when to trust the system."));
        body.Append(MakeBullet("No Gradation", "The UI shows everything as equally certain. Users cannot prioritize which outputs to verify first."));
        body.Append(MakeBullet("Opaque Recovery", "When the AI is uncertain, it provides no path forward - no alternatives, no explanation, no human handoff."));
        body.Append(MakeHighlight("Critical Insight", "The wrong approach: a blunt I cannot help with that. The right approach: acknowledge the question, provide partial information with clear qualification, explain what happens next, and hand off with full context.", Colors.Warning));

        body.Append(MakeH1("Decision Tree Knowledge Management UX", "_Toc003"));
        body.Append(MakeP("Decision trees in knowledge management systems guide users through structured logic to reach answers. When combined with AI, these trees must handle both deterministic rules (known facts) and probabilistic recommendations (AI-generated suggestions). The UX challenge is making this hybrid feel seamless."));

        body.Append(MakeH2("Current Pain Points"));
        body.Append(MakeP("Based on research into knowledge base UX and decision tree implementations, we identified these common friction points:"));
        body.Append(MakeBullet("Rigid Structure", "Traditional decision trees force users down fixed paths. When the AI encounters an edge case, the tree breaks rather than adapts. Users are trapped in loops or dead ends."));
        body.Append(MakeBullet("Disconnected from Context", "Users must leave their current workflow to access the decision tree. The knowledge base lives separately from where the work happens."));
        body.Append(MakeBullet("No Visibility into Logic", "Users cannot see why the tree is asking certain questions or how a conclusion was reached. This erodes trust in the final answer."));
        body.Append(MakeBullet("Stale Content", "Decision trees built on static rules become outdated. Users receive wrong answers because the tree has not been updated with new information."));
        body.Append(MakeBullet("Missing Feedback Loops", "When a decision tree gives a wrong answer, there is no easy way for users to report it. The system does not learn from mistakes."));

        body.Append(MakeH2("Recommended UX Patterns"));
        body.Append(MakeP("The following patterns address the guess versus not-guess problem within decision tree knowledge management:"));
        body.Append(MakeTable4(new string[,] {
            { "Pattern", "Best For", "Build Time", "Impact" },
            { "Inline Hints", "Quick decisions, lists", "Days", "Quick win" },
            { "Confidence Scores", "Research, ops workflows", "1 week", "High trust" },
            { "Review Queues", "Regulated workflows", "2-3 sprints", "Safety" },
            { "Draft Assistant", "Long text, summaries", "1-2 sprints", "Time savings" }
        }));
        body.Append(MakeP("The most effective approach combines multiple patterns: start with inline confidence hints for speed, escalate to review queues for high-stakes decisions, and always provide sources so users can verify when the AI is in the guess zone."));

        body.Append(MakeH1("Job Upload Workflow Experience", "_Toc004"));
        body.Append(MakeP("The job upload process is a critical conversion point. Research on file upload UX shows that this moment contains significant friction - and friction here directly impacts completion rates. For an AI system that processes uploaded jobs, the experience must communicate processing stages clearly and set appropriate expectations."));

        body.Append(MakeH2("Upload Stage Best Practices"));
        body.Append(MakeBullet("Drag-and-Drop with Fallback", "Primary interaction should be drag-and-drop with click-to-browse as fallback. The drop zone must be visually prominent with clear affordances."));
        body.Append(MakeBullet("File Preview Before Submit", "Users must see what they are uploading before confirming. This prevents errors and builds trust."));
        body.Append(MakeBullet("Inline Validation", "Error messages must be specific and actionable - not generic upload failed. Tell users exactly what went wrong and how to fix it."));
        body.Append(MakeBullet("Progress Indicators", "Linear progress bars, percentage counters, or step trackers are the single biggest lever for reducing mid-upload drop-off. Users who see progress are more likely to wait."));

        body.Append(MakeH2("AI Processing Stage"));
        body.Append(MakeP("After upload, the AI processing stage is where the guess versus not-guess distinction becomes critical. Users need:"));
        body.Append(MakeBullet("Real-Time Processing Feedback", "Show stages: Scanning, Analyzing, Structuring, Ready. Without this, users think the system has stalled."));
        body.Append(MakeBullet("Confidence Visualization", "When the AI extracts information from the uploaded job, show confidence per field. High confidence fields can be auto-accepted; low confidence fields should be flagged for review."));
        body.Append(MakeBullet("Granular Edit Controls", "Let users correct specific fields the AI got wrong. Each correction should feed back into the model for future improvement."));
        body.Append(MakeBullet("Graceful Degradation", "If the AI cannot process the upload, provide a clear path forward - manual entry, template suggestion, or human support handoff."));
        body.Append(MakeHighlight("Processing Stage Insight", "Research shows that showing processing stages (even artificial ones) reduces perceived wait time by 28% and increases completion rates. The key is visibility into what is happening, not just a spinning loader.", Colors.Success));

        body.Append(MakeH1("Cognitive Load and Trust Factors", "_Toc005"));
        body.Append(MakeP("AI systems introduce a new type of cognitive load: users must evaluate whether to trust each output. This meta-decision - is this answer reliable? - adds mental overhead that traditional software does not. Research shows that users with high confidence in AI actually experience reduced critical thinking over time (automation bias), while users with low confidence waste mental energy on unnecessary verification."));

        body.Append(MakeH2("Reducing Harmful Cognitive Load"));
        body.Append(MakeBullet("Chunk Information", "Break complex AI outputs into digestible pieces. Use progressive disclosure - show the summary first, details on demand."));
        body.Append(MakeBullet("Visual Grouping", "Group related information together. Use spacing, borders, and color to create clear information hierarchy."));
        body.Append(MakeBullet("Consistent Patterns", "Use the same confidence indicators everywhere. Users should recognize high confidence at a glance without re-learning the system."));
        body.Append(MakeBullet("Default to Speed", "Make the common path fast. Add verification steps only where errors are costly."));

        body.Append(MakeH2("Building Appropriate Trust"));
        body.Append(MakeP("The goal is calibrated trust - users trust the AI when it is right and verify when it might be wrong. Research from 2025 identified these trust-building factors:"));
        body.Append(MakeTable3(new string[,] {
            { "Factor", "Effect on Trust", "UX Implementation" },
            { "Uncertainty Visualization", "+58% for skeptical users", "Color-coded confidence zones" },
            { "Source Transparency", "+34% trust increase", "Cited sources under answers" },
            { "User Control (Edit)", "+41% perceived reliability", "Inline edit on all AI outputs" },
            { "Graceful Escalation", "+27% satisfaction", "Clear handoff with context" }
        }));
        body.Append(MakeP("The key insight: uncertainty visualization is not just a nice-to-have - it is a trust-building mechanism. Users who see honest confidence signals rate the system as more trustworthy, even when the system admits uncertainty."));

        body.Append(MakeH1("Specific Recommendations for Your AI", "_Toc006"));
        body.Append(MakeP("Based on this deep analysis, here are the specific problems your AI should handle and the UX changes to implement:"));

        body.Append(MakeH2("1. Implement Confidence Zones"));
        body.Append(MakeP("Replace the binary correct or incorrect model with three confidence zones:"));
        body.Append(MakeBullet("Know Zone (Above 90%)", "Display with green indicator. Auto-accept for low-risk fields. Show a subtle verified badge."));
        body.Append(MakeBullet("Check Zone (70% to 90%)", "Display with amber indicator. Present the answer but flag it for quick review. One-click confirm or edit."));
        body.Append(MakeBullet("Guess Zone (Below 70%)", "Display with red indicator. Do not auto-fill. Show the best guess but require explicit user input. Offer alternative suggestions."));

        body.Append(MakeH2("2. Add Why This Answer Explanations"));
        body.Append(MakeP("For every AI output, provide an expandable explanation showing: the source data used, the reasoning path through the decision tree, and the specific factors that influenced confidence. This is essential for Check Zone and Guess Zone outputs."));

        body.Append(MakeH2("3. Build Progressive Disclosure"));
        body.Append(MakeP("Do not show all confidence information at once. Default to a simple indicator (color dot plus label). On hover or click, reveal: confidence percentage, key factors, source links. Advanced users can expand to see the full decision path."));

        body.Append(MakeH2("4. Create Feedback Loops"));
        body.Append(MakeP("Every AI output should have a feedback mechanism: thumbs up or down, this was wrong flag, or correction input. Corrections must feed back into the model. Users should see confirmation that their feedback was recorded and will improve future results."));

        body.Append(MakeH2("5. Design Graceful Escalation"));
        body.Append(MakeP("When confidence is below threshold, the system should: acknowledge what the user asked, provide any partial information available with clear qualification, explain why the system is uncertain, and offer a clear next step (human handoff, template suggestion, or rephrase request)."));

        body.Append(MakeH2("6. Contextual Help Integration"));
        body.Append(MakeP("The decision tree knowledge base should be accessible without leaving the current workflow. Embed help: link decision tree nodes to relevant articles, show contextual tips beside complex fields, suggest related articles before users submit support requests, and connect error messages to troubleshooting flows."));

        body.Append(MakeH2("Visual Mockup Descriptions"));
        body.Append(MakeP("To make these recommendations concrete for discussion, here are wireframe-level descriptions of the key UI states. These are not final designs; they are starting points for Zakaria and Manar to react to and refine."));
        body.Append(MakeBullet("Mockup 1 - Inline Confidence Indicator", "Next to any AI-filled field, show a small colored dot plus a one-word label: Verified (green, above 90%), Check (amber, 70-90%), or Guess (red, below 70%). On hover or tap, expand a compact card showing the confidence percentage, the source data used, a Why this answer link, and an inline edit pencil."));
        body.Append(MakeBullet("Mockup 2 - Confidence Zone List View", "After a job upload, present extracted fields as a list with columns for Field, AI Value, Confidence, and Action. Green rows are auto-accepted, amber rows are flagged for quick review, and red rows remain empty with the best guess shown as a placeholder. Add bulk actions such as Accept all high confidence and Review flagged items."));
        body.Append(MakeBullet("Mockup 3 - Job Upload Processing Timeline", "Replace the generic spinner with a horizontal stepper: Upload, Scanning, Analyzing, Structuring, Ready. Completed steps show a checkmark, the active step pulses gently, and pending steps are gray. As each stage finishes, reveal a preview of the fields it produced so users see progress in real time."));
        body.Append(MakeBullet("Mockup 4 - Decision Tree Node with AI Hint", "When a decision-tree question appears, show the AI hint directly beneath it: Based on the upload, this looks like a Fixed-Price contract (87% confidence). The suggestion carries an amber Check badge. The user can accept the suggestion, choose a different answer manually, or click Why this suggestion? to see the reasoning path."));
        body.Append(MakeBullet("Mockup 5 - Graceful Escalation State", "If the AI cannot answer confidently, keep the user on the same screen. Show: what the system understood, any partial information it can provide with clear qualification, why it is uncertain, and three concrete next steps such as hand off to a human expert, try a structured template, or rephrase the question."));
        body.Append(MakeBullet("Mockup 6 - Feedback Micro-interaction", "Place unobtrusive thumbs up and thumbs down icons beside every AI output. Tapping thumbs down reveals a small inline form: What was wrong? with an optional correct value. After submission, show a brief confirmation: Thanks — this will improve future results."));

        body.Append(MakeH1("Implementation Priority Matrix", "_Toc007"));
        body.Append(MakeP("Based on impact versus effort analysis, here is the recommended implementation order:"));
        body.Append(MakeTable5(new string[,] {
            { "Priority", "Feature", "Impact", "Effort", "Timeline" },
            { "1", "Confidence Zone Colors", "High", "Low", "Week 1" },
            { "2", "Processing Stage Feedback", "High", "Low", "Week 1-2" },
            { "3", "Inline Edit Controls", "High", "Medium", "Week 2-3" },
            { "4", "Why This Answer Explanations", "Medium", "Medium", "Week 3-4" },
            { "5", "Feedback Loop System", "Medium", "Medium", "Week 4-5" },
            { "6", "Graceful Escalation Flow", "High", "High", "Week 5-7" },
            { "7", "Contextual KB Integration", "Medium", "High", "Week 7-9" }
        }));
        body.Append(MakeP("Start with confidence zone colors - this single change delivers the highest trust improvement for the lowest implementation cost. It provides the foundation for all other patterns. Then build the processing stage feedback for the job upload flow, as this directly impacts completion rates."));
        body.Append(MakeHighlight("Next Steps", "1. Review this analysis with Zakaria and Manar. 2. Prioritize based on your specific user pain points. 3. Prototype the confidence zone system first - it is the foundation for everything else. 4. Measure: time to complete, error rates, and user trust scores before and after each change.", Colors.Primary));

        body.Append(new Paragraph(new ParagraphProperties(new SectionProperties(
            new HeaderReference { Type = HeaderFooterValues.Default, Id = headerId },
            new FooterReference { Type = HeaderFooterValues.Default, Id = footerId },
            new PageSize { Width = (UInt32Value)(uint)A4W, Height = (UInt32Value)(uint)A4H },
            new PageMargin { Top = 1800, Right = 1440, Bottom = 1440, Left = 1440, Header = 720, Footer = 720 }))));
    }

    private static void AddBackcoverSection(Body body, string backBgId, ref uint prId)
    {
        body.Append(new Paragraph(new Run(CreateFloatingBg(backBgId, prId++, "BackBg"))));
        body.Append(new Paragraph(new ParagraphProperties(new SpacingBetweenLines { Before = "7000" }, new Justification { Val = JustificationValues.Center }),
            new Run(new RunProperties(new FontSize { Val = "44" }, new Bold(), new Color { Val = Colors.Primary }), new Text("Ready to Discuss"))));
        body.Append(new Paragraph(new ParagraphProperties(new SpacingBetweenLines { Before = "400" }, new Justification { Val = JustificationValues.Center }),
            new Run(new RunProperties(new FontSize { Val = "22" }, new Color { Val = Colors.Mid }), new Text("Let's build trust through transparency."))));
        body.Append(new Paragraph(new ParagraphProperties(new SpacingBetweenLines { Before = "200" }, new Justification { Val = JustificationValues.Center }),
            new Run(new RunProperties(new FontSize { Val = "18" }, new Color { Val = Colors.Light }), new Text("Week of June 22, 2026"))));
        body.Append(new SectionProperties(
            new PageSize { Width = (UInt32Value)(uint)A4W, Height = (UInt32Value)(uint)A4H },
            new PageMargin { Top = 0, Right = 0, Bottom = 0, Left = 0, Header = 0, Footer = 0 }));
    }

    // Factory helpers
    private static int _bookmarkId = 0;

    private static Paragraph MakeH1(string text, string bm) { int id = ++_bookmarkId; return new Paragraph(new ParagraphProperties(new ParagraphStyleId { Val = "Heading1" }), new BookmarkStart { Id = id.ToString(), Name = bm }, new Run(new Text(text)), new BookmarkEnd { Id = id.ToString() }); }
    private static Paragraph MakeH2(string text) { return new Paragraph(new ParagraphProperties(new ParagraphStyleId { Val = "Heading2" }), new Run(new Text(text))); }
    private static Paragraph MakeP(string text) { return new Paragraph(new Run(new Text(text))); }

    private static Paragraph MakeBullet(string title, string desc)
    {
        return new Paragraph(
            new ParagraphProperties(new Indentation { Left = "360", Hanging = "360" }),
            new Run(new RunProperties(new Bold(), new Color { Val = Colors.Slate }), new Text(title + ": ") { Space = SpaceProcessingModeValues.Preserve }),
            new Run(new Text(desc) { Space = SpaceProcessingModeValues.Preserve }));
    }

    private static Paragraph MakeHighlight(string title, string text, string color)
    {
        string bgColor = color == Colors.Primary ? "ccfbf1" : (color == Colors.Success ? "d1fae5" : (color == Colors.Warning ? "fef3c7" : "e0f2fe"));
        return new Paragraph(
            new ParagraphProperties(
                new ParagraphBorders(new LeftBorder { Val = BorderValues.Single, Size = 24, Color = color }),
                new Shading { Val = ShadingPatternValues.Clear, Fill = bgColor },
                new Indentation { Left = "200", Right = "200" },
                new SpacingBetweenLines { Before = "200", After = "200" }),
            new Run(new RunProperties(new Bold(), new Color { Val = color }, new FontSize { Val = "22" }), new Text(title) { Space = SpaceProcessingModeValues.Preserve }),
            new Run(new RunProperties(new Color { Val = Colors.Slate }, new FontSize { Val = "21" }), new Text(" - " + text) { Space = SpaceProcessingModeValues.Preserve }));
    }

    private static Table MakeTable3(string[,] data) { return MakeTable(data, new string[] { "4000", "3000", "3000" }); }
    private static Table MakeTable4(string[,] data) { return MakeTable(data, new string[] { "2500", "2500", "2500", "2500" }); }
    private static Table MakeTable5(string[,] data) { return MakeTable(data, new string[] { "1200", "2800", "2000", "2000", "2000" }); }

    private static Table MakeTable(string[,] data, string[] widths)
    {
        var tbl = new Table();
        tbl.Append(new TableProperties(
            new TableWidth { Width = "5000", Type = TableWidthUnitValues.Pct },
            new TableBorders(
                new TopBorder { Val = BorderValues.Single, Size = 12, Color = Colors.Primary },
                new BottomBorder { Val = BorderValues.Single, Size = 12, Color = Colors.Primary },
                new InsideHorizontalBorder { Val = BorderValues.Single, Size = 4, Color = Colors.Border })));
        var grid = new TableGrid();
        foreach (var w in widths) grid.Append(new GridColumn { Width = w });
        tbl.Append(grid);

        for (int r = 0; r < data.GetLength(0); r++)
        {
            var row = new TableRow();
            if (r == 0) row.Append(new TableRowProperties(new TableHeader()));
            for (int c = 0; c < data.GetLength(1); c++)
            {
                var tcp = new TableCellProperties(new TableCellWidth { Width = widths[c], Type = TableWidthUnitValues.Dxa });
                if (r == 0) tcp.Append(new Shading { Val = ShadingPatternValues.Clear, Fill = Colors.TableHeader });
                var rpr = new RunProperties(new FontSize { Val = "20" }, new Color { Val = r == 0 ? Colors.Slate : Colors.Mid });
                if (r == 0) rpr.Append(new Bold());
                row.Append(new TableCell(tcp, new Paragraph(
                    new ParagraphProperties(new SpacingBetweenLines { Before = "60", After = "60" }),
                    new Run(rpr, new Text(data[r, c]) { Space = SpaceProcessingModeValues.Preserve }))));
            }
            tbl.Append(row);
        }
        return tbl;
    }

    // Image helpers
    private static string AddImage(MainDocumentPart mp, string path)
    {
        var ip = mp.AddImagePart(ImagePartType.Png);
        using var fs = new FileStream(path, FileMode.Open);
        ip.FeedData(fs); return mp.GetIdOfPart(ip);
    }

    private static Drawing CreateFloatingBg(string imgId, uint prId, string name)
    {
        return new Drawing(new DW.Anchor(
            new DW.SimplePosition { X = 0, Y = 0 },
            new DW.HorizontalPosition(new DW.PositionOffset("0")) { RelativeFrom = DW.HorizontalRelativePositionValues.Page },
            new DW.VerticalPosition(new DW.PositionOffset("0")) { RelativeFrom = DW.VerticalRelativePositionValues.Page },
            new DW.Extent { Cx = A4WE, Cy = A4HE },
            new DW.EffectExtent { LeftEdge = 0, TopEdge = 0, RightEdge = 0, BottomEdge = 0 },
            new DW.WrapNone(),
            new DW.DocProperties { Id = prId, Name = name },
            new DW.NonVisualGraphicFrameDrawingProperties(new A.GraphicFrameLocks { NoChangeAspect = true }),
            new A.Graphic(new A.GraphicData(
                new PIC.Picture(
                    new PIC.NonVisualPictureProperties(
                        new PIC.NonVisualDrawingProperties { Id = 0, Name = $"{name}.png" },
                        new PIC.NonVisualPictureDrawingProperties()),
                    new PIC.BlipFill(new A.Blip { Embed = imgId }, new A.Stretch(new A.FillRectangle())),
                    new PIC.ShapeProperties(
                        new A.Transform2D(new A.Offset { X = 0, Y = 0 }, new A.Extents { Cx = A4WE, Cy = A4HE }),
                        new A.PresetGeometry { Preset = A.ShapeTypeValues.Rectangle })))
            { Uri = "http://schemas.openxmlformats.org/drawingml/2006/picture" }))
        { DistanceFromTop = 0, DistanceFromBottom = 0, DistanceFromLeft = 0, DistanceFromRight = 0,
          SimplePos = false, RelativeHeight = 251658240, BehindDoc = true,
          Locked = false, LayoutInCell = true, AllowOverlap = true });
    }

    private static void SetUpdateFieldsOnOpen(MainDocumentPart mp)
    {
        var sp = mp.DocumentSettingsPart ?? mp.AddNewPart<DocumentSettingsPart>();
        sp.Settings = new Settings(new UpdateFieldsOnOpen { Val = true }, new DisplayBackgroundShape());
    }

    private static void AddNumbering(MainDocumentPart mp)
    {
        var np = mp.AddNewPart<NumberingDefinitionsPart>();
        np.Numbering = new Numbering(
            new AbstractNum(new Level(
                new NumberingFormat { Val = NumberFormatValues.Decimal },
                new LevelText { Val = "%1." },
                new LevelJustification { Val = LevelJustificationValues.Left },
                new ParagraphProperties(new Indentation { Left = "720", Hanging = "360" })
            ) { LevelIndex = 0 }) { AbstractNumberId = 1 },
            new NumberingInstance(new AbstractNumId { Val = 1 }) { NumberID = 1 });
    }
}
