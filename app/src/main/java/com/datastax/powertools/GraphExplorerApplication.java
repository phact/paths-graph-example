package com.datastax.powertools;

import com.datastax.powertools.managed.Dse;
import com.datastax.powertools.resources.GraphExplorerResource;
import io.dropwizard.Application;
import io.dropwizard.assets.AssetsBundle;
import io.dropwizard.configuration.EnvironmentVariableSubstitutor;
import io.dropwizard.configuration.SubstitutingSourceProvider;
import io.dropwizard.setup.Bootstrap;
import io.dropwizard.setup.Environment;
import java.util.EnumSet;
import javax.servlet.DispatcherType;
import javax.servlet.FilterRegistration;
import org.eclipse.jetty.servlets.CrossOriginFilter;

/**
 * Created by sebastianestevez on 3/26/18.
 */
public class GraphExplorerApplication extends Application<GraphExplorerConfig> {

    public static void main(String[] args) throws Exception{
        new GraphExplorerApplication().run(args);
    }

    @Override
    public void initialize(Bootstrap<GraphExplorerConfig> bootstrap) {

        bootstrap.addBundle(new AssetsBundle("/assets/","/", "index.html"));

        // Enable variable substitution with environment variables
        bootstrap.setConfigurationSourceProvider(
                new SubstitutingSourceProvider(bootstrap.getConfigurationSourceProvider(),
                        new EnvironmentVariableSubstitutor(false)
                )
        );

        super.initialize(bootstrap);
    }

    public void run(GraphExplorerConfig graphExplorerConfig, Environment environment) throws Exception {

        Dse dse = new Dse(graphExplorerConfig);
        dse.start();

        // Enable CORS for npm dev mode
        final FilterRegistration.Dynamic cors = environment.servlets()
                .addFilter("cors", CrossOriginFilter.class);
        cors.setInitParameter("allowedOrigins", "*");
        cors.setInitParameter("allowedHeaders", "X-Requested-With,authorization,Content-Type,Accept,Origin");
        cors.setInitParameter("allowedMethods", "OPTIONS,GET,PUT,POST,DELETE,HEAD");

        cors.addMappingForUrlPatterns(EnumSet.allOf(DispatcherType.class), true,
                "/*");


        GraphExplorerResource graphExplorerResource = new GraphExplorerResource(dse, graphExplorerConfig);
        environment.jersey().register(graphExplorerResource);
    }
}
