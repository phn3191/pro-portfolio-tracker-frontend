package main

import (
	"net/http"
	"sync"

	"github.com/gin-gonic/gin"
)

type Achievement struct {
	ID          int    `json:"id"`
	Description string `json:"description"`
	Impact      string `json:"impact"`
	SkillUsed   string `json:"skill_used"`
}

type Trophy struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

var (
	achievements = []Achievement{
		{ID: 1, Description: "Built a scalable REST API", Impact: "Improved system reliability", SkillUsed: "Go"},
		{ID: 2, Description: "Migrated database to PostgreSQL", Impact: "Enhanced data integrity", SkillUsed: "SQL"},
	}
	trophies = []Trophy{
		{ID: 1, Name: "API Master"},
		{ID: 2, Name: "Database Guru"},
	}
	achMutex    sync.Mutex
	trophyMutex sync.Mutex
	achID       = 2
	trophyID    = 2
)

func getAchievements(c *gin.Context) {
	achMutex.Lock()
	defer achMutex.Unlock()
	c.JSON(http.StatusOK, achievements)
}

func createAchievement(c *gin.Context) {
	var a Achievement
	if err := c.ShouldBindJSON(&a); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}
	achMutex.Lock()
	achID++
	a.ID = achID
	achievements = append(achievements, a)
	achMutex.Unlock()
	c.JSON(http.StatusCreated, a)
}

func getTrophies(c *gin.Context) {
	trophyMutex.Lock()
	defer trophyMutex.Unlock()
	c.JSON(http.StatusOK, trophies)
}

func createTrophy(c *gin.Context) {
	var t Trophy
	if err := c.ShouldBindJSON(&t); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}
	trophyMutex.Lock()
	trophyID++
	t.ID = trophyID
	trophies = append(trophies, t)
	trophyMutex.Unlock()
	c.JSON(http.StatusCreated, t)
}

func main() {
	r := gin.Default()

	r.GET("/achievements", getAchievements)
	r.POST("/achievements", createAchievement)

	r.GET("/trophies", getTrophies)
	r.POST("/trophies", createTrophy)

	r.Run(":8080") // listen and serve on 0.0.0.0:8080
}
