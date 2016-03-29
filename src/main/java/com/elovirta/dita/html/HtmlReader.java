package com.elovirta.dita.html;

import nu.validator.htmlparser.common.DoctypeExpectation;
import nu.validator.htmlparser.common.Heuristics;
import nu.validator.htmlparser.sax.HtmlParser;
import org.xml.sax.*;

import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.sax.SAXTransformerFactory;
import javax.xml.transform.sax.TransformerHandler;
import javax.xml.transform.stream.StreamSource;
import java.io.IOException;

/**
 * XMLReader implementation for HDITA.
 */
public class HtmlReader implements XMLReader {

    private final HtmlParser parser;
    private final TransformerHandler transformerHandler;
    private final SAXResult result;

    public HtmlReader() {
        parser = new HtmlParser();
        parser.setDoctypeExpectation(DoctypeExpectation.AUTO);
        parser.setHeuristics(Heuristics.ICU);
        try {
            result = new SAXResult();
            final TransformerFactory transformerFactory = TransformerFactory.newInstance();
            final StreamSource src = new StreamSource(this.getClass().getClassLoader().getResourceAsStream("hdita2dita.xsl"),
                    "classpath:///hdita2dita.xsl");
            transformerHandler = ((SAXTransformerFactory) transformerFactory).newTransformerHandler(src);
            transformerHandler.setResult(result);
            parser.setContentHandler(transformerHandler);
            parser.setLexicalHandler(transformerHandler);
            parser.setDTDHandler(transformerHandler);
        } catch (final TransformerConfigurationException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public boolean getFeature(String name) throws SAXNotRecognizedException, SAXNotSupportedException {
        return parser.getFeature(name);
    }

    @Override
    public void setFeature(String name, boolean value) throws SAXNotRecognizedException, SAXNotSupportedException {
        parser.setFeature(name, value);
    }

    @Override
    public Object getProperty(String name) throws SAXNotRecognizedException, SAXNotSupportedException {
        return parser.getProperty(name);
    }

    @Override
    public void setProperty(String name, Object value) throws SAXNotRecognizedException, SAXNotSupportedException {
        parser.setProperty(name, value);
    }

    @Override
    public void setEntityResolver(final EntityResolver resolver) {
        // Validator.nu is unable to parse by URI only, it will always need a stream
        parser.setEntityResolver(new EntityResolver() {
            @Override
            public InputSource resolveEntity(final String publicId, final String systemId) throws SAXException, IOException {
                final InputSource in = resolver.resolveEntity(publicId, systemId);
                if (in != null) {
                    return in;
                }
                return new InputSource(systemId);
            }
        });
    }

    @Override
    public EntityResolver getEntityResolver() {
        return parser.getEntityResolver();
    }

    @Override
    public void setDTDHandler(final DTDHandler handler) {
        parser.setDTDHandler(handler);
    }

    @Override
    public DTDHandler getDTDHandler() {
        return parser.getDTDHandler();
    }

    @Override
    public void setContentHandler(final ContentHandler handler) {
        result.setHandler(handler);
    }

    @Override
    public ContentHandler getContentHandler() {
        return result.getHandler();
    }

    @Override
    public void setErrorHandler(final ErrorHandler handler) {
        parser.setErrorHandler(handler);
    }

    @Override
    public ErrorHandler getErrorHandler() {
        return parser.getErrorHandler();
    }

    @Override
    public void parse(final InputSource input) throws IOException, SAXException {
        parser.parse(input);
    }

    @Override
    public void parse(final String systemId) throws IOException, SAXException {
        parser.parse(systemId);
    }

}
