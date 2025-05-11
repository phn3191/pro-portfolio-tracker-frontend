package main

import (
	"log"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"

	"pro-portfolio-tracker/model"
)

var db *gorm.DB

type AchievementInput struct {
	Description     string `json:"description"`
	Impact          string `json:"impact"`
	SkillUsed       string `json:"skill_used"`
	AchievementDate string `json:"achievement_date"`
}

type TrophyInput struct {
	Name       string `json:"name"`
	TrophyDate string `json:"trophy_date"`
}

func getAchievements(c *gin.Context) {
	var achievements []model.Achievement
	if err := db.Find(&achievements).Error; err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, achievements)
}

func createAchievement(c *gin.Context) {

	var input AchievementInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request body"})
		return
	}
	parsedDate, err := time.Parse("2006-01-02", input.AchievementDate)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid achievement_date format, use YYYY-MM-DD"})
		return
	}
	a := model.Achievement{
		Description:     input.Description,
		Impact:          input.Impact,
		SkillUsed:       input.SkillUsed,
		AchievementDate: parsedDate,
	}
	if err := db.Create(&a).Error; err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	c.JSON(201, a)
}

func getTrophies(c *gin.Context) {
	var trophies []model.Trophy
	if err := db.Find(&trophies).Error; err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	c.JSON(200, trophies)
}

func createTrophy(c *gin.Context) {
	var input TrophyInput
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error": "Invalid request body"})
		return
	}
	parsedDate, err := time.Parse("2006-01-02", input.TrophyDate)
	if err != nil {
		c.JSON(400, gin.H{"error": "Invalid trophy_date format, use YYYY-MM-DD"})
		return
	}
	t := model.Trophy{
		Description: input.Name,
		TrophyDate:  parsedDate,
	}
	if err := db.Create(&t).Error; err != nil {
		c.JSON(500, gin.H{"error": err.Error()})
		return
	}
	c.JSON(201, t)
}

func main() {
	dsn := os.Getenv("DATABASE_URL")
	if dsn == "" {
		dsn = "host=localhost user=postgres password=postgres dbname=pro_portfolio_tracker port=5432 sslmode=disable"
	}
	var err error
	db, err = gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	db.AutoMigrate(&model.Achievement{}, &model.Trophy{}, &model.User{})

	r := gin.Default()
	r.Use(cors.Default())

	r.GET("/achievements", getAchievements)
	r.POST("/achievements", createAchievement)

	r.GET("/trophies", getTrophies)
	r.POST("/trophies", createTrophy)

	r.Run(":8080") // listen and serve on 0.0.0.0:8080
}
