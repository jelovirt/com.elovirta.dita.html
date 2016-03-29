package com.elovirta.dita.html;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xmlunit.builder.Input;
import org.xmlunit.matchers.CompareMatcher;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMResult;
import javax.xml.transform.sax.SAXSource;
import java.io.InputStream;
import java.util.Arrays;
import java.util.Collection;

import static org.junit.Assert.assertThat;

@RunWith(Parameterized.class)
public class HtmlReaderTest {

    @Parameterized.Parameters(name = "{0}")
    public static Collection<Object[]> data() {
        return Arrays.asList(new Object[][]{
                {"test"},
                {"hdita"}
        });
    }

    private final TransformerFactory transformerFactory;
    private final DocumentBuilder bf;
    private final String input;

    public HtmlReaderTest(final String input) throws ParserConfigurationException {
        this.input = input;
        transformerFactory = TransformerFactory.newInstance();
        bf = DocumentBuilderFactory.newInstance().newDocumentBuilder();
    }

    @Test
    public void test() throws Exception {
        final Transformer t = transformerFactory.newTransformer();
        final HtmlReader r = new HtmlReader();
        try (final InputStream ri = getClass().getResourceAsStream("/" + input + ".html");
             final InputStream exp = getClass().getResourceAsStream("/" + input + ".dita")) {
            final InputSource i = new InputSource(ri);
            final Document act = bf.newDocument();
            t.transform(new SAXSource(r, i), new DOMResult(act));

            assertThat(act, CompareMatcher
                    .isSimilarTo(Input.fromStream(exp))
                    .normalizeWhitespace());
        }
    }

}