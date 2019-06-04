using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Npgsql;

namespace SampleApi
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IHostingEnvironment env, ILogger<Startup> logger)
        {
            Configuration = configuration;
            Env = env;
            MigrateDatabase(logger);
        }

        public IConfiguration Configuration { get; }
        public IHostingEnvironment Env { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_2_1);
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseHsts();
            }

            app.UseHttpsRedirection();
            app.UseMvc();
        }


        private void MigrateDatabase(ILogger<Startup> logger)
        {
            string location = Env.IsProduction() || Env.IsStaging() // exclude db/datasets from production environment
                ? "Db/Migration"
                : "db";

            try
            {
                NpgsqlConnection cnx = new NpgsqlConnection(Configuration.GetConnectionString("MyDatabase"));
                var evolve = new Evolve.Evolve(cnx, msg => logger.LogInformation(msg))
                {
                    Locations = new[] { location },
                    IsEraseDisabled = true,
                    Placeholders = new Dictionary<string, string>
                    {
                        ["${table4}"] = "table4"
                    }
                };

                evolve.Migrate();
            }
            catch (Exception ex)
            {
                logger.LogCritical("Database migration failed.", ex);
                throw;
            }
        }
    }
}
